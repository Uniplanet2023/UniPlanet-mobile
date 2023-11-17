import { createClient, RedisClientType } from 'redis';
import * as socketController from '../socket/socket_router';
import { Server } from 'http';

let pubClient: RedisClientType;
let subClient: RedisClientType;

export const init = async (server: Server): Promise<void> => {
  console.log(process.env.REDIS_PORT);
  console.log(process.env.REDIS_HOST);
  pubClient = createClient({
    password: process.env.REDIS_PASSWORD, // Use environment variable
    socket: {
      host: process.env.REDIS_HOST,
      port: parseInt(process.env.REDIS_PORT || '6379'),
    },
  });

  subClient = pubClient.duplicate();

  // Redis DB Setting
  pubClient.on('error', (err) => console.log('Redis Client Error', err));
  pubClient.on('connect', () =>
    console.log('2-1. Redis Connection: Pub Client Connected')
  );
  subClient.on('connect', () =>
    console.log('2-2. Redis Connection: Sub Client Connected')
  );

  // DB, Redis Connections
  await Promise.all([pubClient.connect(), subClient.connect()]);
  socketController.init(server, pubClient, subClient);
};

export const set = async (key: string, value: any): Promise<void> => {
  try {
    if (!pubClient) {
      throw new Error('Redis client is not initialized');
    }
    await pubClient.set(key, JSON.stringify(value), {
      EX: 36000,
      NX: true,
    });
  } catch (e) {
    console.error(e);
  }
};

export const get = async (key: string): Promise<string | false> => {
  try {
    if (!pubClient) {
      throw new Error('Redis client is not initialized');
    }
    const value = await pubClient.get(key);
    return value === null ? false : value;
  } catch (e) {
    console.error(e);
    return false;
  }
};

export const setJson = async (
  key: string,
  path: string,
  listValue: any[]
): Promise<void> => {
  try {
    if (!pubClient) {
      throw new Error('Redis client is not initialized');
    }
    if (!listValue || !Array.isArray(listValue) || listValue.length === 0) {
      await pubClient.json.set(key, path, []);
      console.log('Invalid List Or Empty Products');
    } else {
      await pubClient.json.set(key, path, listValue);
    }
  } catch (e) {
    console.error(e);
  }
};

export const addJson = async (key: string, value: any): Promise<void> => {
  try {
    if (!pubClient) {
      throw new Error('Redis client is not initialized');
    }
    await pubClient.json.arrAppend(key, '$', value);
  } catch (e) {
    console.error(e);
  }
};

export const getJson = async (key: string): Promise<any> => {
  try {
    if (!pubClient) {
      throw new Error('Redis client is not initialized');
    }
    let jsonProducts = await pubClient.json.get(key);
    return jsonProducts;
  } catch (e) {
    console.error(e);
  }
};
