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