import { pool } from "../config/db.js";

export const getCurrentWd = async (req, res) => {
    const result = await pool.query(
        'SELECT * FROM workday WHERE close_date IS NULL LIMIT 1'
    );

    if (result.rows.length === 0) {
        return res.json(null);
    }

    res.json(result.rows[0]);
};

export const openWd = async (req, res) => {
    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        const existing = await client.query(
            'SELECT id FROM workday WHERE close_date IS NULL LIMIT 1'
        );

        if (existing.rows.length > 0) {
            await client.query('ROLLBACK');
            return res.status(409).json({
                message: 'Ya existe una jornada abierta'
            });
        }

        const result = await client.query(
            'INSERT INTO workday (start_date) VALUES (NOW()) RETURNING *'
        );

        await client.query('COMMIT');
        res.status(201).json(result.rows[0]);
    } catch (error) {
        await client.query('ROLLBACK');
        res.status(500).json({error: 'Error al abrir jornada'});
    } finally {
        client.release();
    }
};

export const closeWd = async (req, res) => {
    const {id} = req.params;

    const result = await pool.query(
        `UPDATE workday SET close_date = NOW() WHERE id = $1 AND close_date is NULL RETURNING *`, [id]
    );

    if (result.rowCount === 0) {
        return res.status(400).json({
            message: 'Jornada no encontrada o ya cerrada'
        });
    }

    res.json({
        message: 'Jornada cerrada exitosamente',
        workday: result.rows[0]
    });
};