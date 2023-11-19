import express from 'express';
import http, { Server } from 'http';
import dotenv from 'dotenv';
import redisInit from './redis_controller/redis_controller';

// IMPORTS FROM OTHER FILES
import { authRouter } from './routes';

import productRouter from './routes/product';
import userRouter from './routes/user';
import likeRouter from './routes/like';
import chatRouter from './routes/chat';

// INIT
dotenv.config();

const app = express();
const server: Server = http.createServer(app);
redisInit(server);

// middleware
app.use(express.json());
app.use(authRouter);
app.use(chatRouter);
app.use(userRouter);
app.use(productRouter);
app.use(likeRouter);

export default server;
