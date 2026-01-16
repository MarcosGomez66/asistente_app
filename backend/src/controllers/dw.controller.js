import { pool } from "../config/db.js";

export const getCurrentDw = async (req, res) => {
    const result = await pool.query(
        'SELECT * FROM workday WHERE close_date IS NULL LIMIT 1'
    );
    res.json(result.rows[0] ?? null)
};

export const openDw = async (req, res) => {
    const result = await pool.query(
        'INSERT INTO workday (start_date) VALUES (NOW()) RETURNING *'
    );
    res.status(201).json(result.rows[0]);
};

export const closeDw = async (req, res) => {
    const { id } = req.params;

    await pool.query(
        'UPDATE workday SET close_date = NOW() WHERE id = $1', [id]
    );
    res.json({ message: 'Jornada de trabajo cerrada exitosamente' });
};