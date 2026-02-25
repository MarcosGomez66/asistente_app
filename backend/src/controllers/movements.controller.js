import { pool } from "../config/db.js";

export const adjustStock = async (req, res) => {
    const { id } = req.params;
    const { newStock, reason } = req.body;

    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        const productResult = await client.query(
            `SELECT stock FROM products WHERE id = $1 FOR UPDATE`,
            [id]
        );

        if (productResult.rows.length === 0) {
            await client.query('ROLLBACK');
            return res.status(404).json({ message: 'Producto no encontrado' });
        }

        const currentStock = Number(productResult.rows[0].stock)
        const difference = Number(newStock) - currentStock;

        if (difference === 0) {
            await client.query('ROLLBACK');
            return res.status(400).json({ message: 'No hay cambios en el stock' });
        }

        await client.query(
            `INSERT INTO stock_movements
            (product_id, quantity, type, reason, previous_stock, new_stock)
            VALUES ($1, $2, $3, $4, $5, $6)`,
            [
                id,
                difference,
                'ADJUST',
                reason || 'manual_adjust',
                currentStock,
                newStock
            ]
        );

        await client.query(
            `UPDATE products SET stock = $1, updated_at = NOW() WHERE id = $2`,
            [newStock, id]
        );

        await client.query('COMMIT');

        res.json({ message: 'Stock ajustado correctamente' });

    } catch (error) {
        await client.query('ROLLBACK');
        console.error('Error adjustStock: ', error);
        res.status(500).json({ message: 'Error interno' });
    } finally {
        client.release();
    }
};