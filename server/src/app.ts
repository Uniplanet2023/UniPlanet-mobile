import express from 'express';
import 'express-async-errors';
import { createServer, Server } from 'http';
import redisInit from './redis_controller/redis_controller';
import { errorHandler } from './middlewares';
// IMPORTS FROM OTHER FILES
import { authRouter, productRouter } from './routes';
import userRouter from './routes/user';
import likeRouter from './routes/like';
import chatRouter from './routes/chat';

const app = express();

// middleware
app.use(express.json());
app.use(authRouter);
app.use(chatRouter);
app.use(userRouter);
app.use(productRouter);
app.use(likeRouter);
app.use(errorHandler);

const server: Server = createServer(app);
redisInit(server);

export default app;
