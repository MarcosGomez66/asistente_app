import { Router } from 'express';
import { adjustStock } from '../controllers/movements.controller.js';

const router = Router();

router.post('/:id/adjust', adjustStock);

export default router;