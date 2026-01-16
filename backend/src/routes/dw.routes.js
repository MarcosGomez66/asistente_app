import {Router} from 'express';
import {
    getCurrentDw,
    openDw,
    closeDw
} from '../controllers/dw.controller.js';

const router = Router();

router.get('/actual', getCurrentDw);
router.post('/abrir', openDw);
router.post('/cerrar/:id', closeDw);

export default router;