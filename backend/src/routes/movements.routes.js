import { Router } from 'express';
import { adjustStock, wasteStock } from '../controllers/movements.controller.js';

const router = Router();

router.post('/:id/adjust', adjustStock);
router.post('/:id/waste', wasteStock);

export default router;