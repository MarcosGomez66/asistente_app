import { pool } from "../config/db.js";

export const getProducts = async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT id, name, description, sale_price, cost_price, stock, min_stock, unit, is_active,
            created_at, updated_at FROM products WHERE is_active = true ORDER BY name ASC`
        );

        const products = result.rows.map(row => ({
            id: row.id,
            name: row.name,
            description: row.description,

            sale_price: Number(row.sale_price),
            cost_price: Number(row.cost_price),
            stock: Number(row.stock),
            min_stock: Number(row.min_stock),

            unit: row.unit,
            is_active: row.is_active,
            created_at: row.created_at,
            updated_at: row.updated_at
        }));

        res.json(products);
    } catch (error) {
        console.error('Error getProducts:', error);
        res.status(500).json({ message: 'Error al obtener productos'});
    }
};

export const createProduct = async (req, res) => {
    const client = await pool.connect();

    try {
        const {
            name,
            description,
            salePrice,
            costPrice,
            stock,
            minStock,
            unit,
        } = req.body;

        await client.query('BEGIN');

        const productResult = await client.query(
            `
            INSERT INTO products
            (name, description, sale_price, cost_price, stock, min_stock, unit)
            VALUES ($1,$2,$3,$4,$5,$6,$7)
            RETURNING *
            `,
            [
                name,
                description,
                salePrice,
                costPrice,
                stock,
                minStock,
                unit
            ]
        );

        const product = productResult.rows[0];

        // Si hay stock inicial se crea el movimiento
        if (stock && stock > 0) {
            await client.query(
                `
                INSERT INTO stock_movements
                (product_id, quantity, type, reason)
                VALUES ($1,$2,'IN','Stock inicial')
                `,
                [product.id, stock]
            );
        }

        await client.query('COMMIT');

        res.status(201).json(product);
    } catch (error) {
        await client.query('ROLLBACK');
        console.error(error);
        res.status(500).json({ message: 'Error al crear producto'});
    } finally {
        client.release();
    }
};