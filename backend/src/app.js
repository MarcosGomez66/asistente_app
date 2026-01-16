import express from 'express';
import cors from 'cors';
import dwRoutes from './routes/dw.routes.js';

const app = express();

app.use(cors());
app.use(express.json());

app.use('/jornada', dwRoutes)

export default app;