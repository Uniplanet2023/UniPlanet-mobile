import mongoose from 'mongoose';
import server from './app';

const PORT = process.env.PORT || 3000;

mongoose.connect(process.env.MONGO_DB_HOST as string).then(() => {
  console.log('3. DB Connection : Mongo DB Connection Successful');
  console.log(
    '\x1b[32m------------------- All the Connect is successfully connected -------------------\x1b[0m '
  );
  console.log('');
});

server.listen(PORT, () => {
  console.log('');
  console.info(
    '\x1b[32m------------------- Back End Connection is Staring -------------------\x1b[0m'
  );
  console.log(
    `1. BackEnd Connection : BackEnd Server connected at port ${PORT}`
  );
});
