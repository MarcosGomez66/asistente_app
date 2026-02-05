import express from 'express';
import cors from 'cors';
import wdRoutes from './routes/wd.routes.js';
import productRoutes from './routes/products.routes.js';

const app = express();

app.use(cors());
app.use(express.json());

app.use('/workday', wdRoutes)
app.use('/products', productRoutes)

export default app;