import {Router} from 'express';
import {
    getCurrentWd,
    openWd,
    closeWd
} from '../controllers/wd.controller.js';

const router = Router();

router.get('/current', getCurrentWd);
router.post('/start', openWd);
router.put('/close/:id', closeWd);

export default router;