const redis = require("redis");
const socketController = require("../socket/socket_router");
let pubClient;
let subClient;
module.exports = {
  init: async (server) => {
    pubClient = redis.createClient({
      password: process.env.REDIS_PASSWORD, // Use environment variable
      socket: {
        host: process.env.REDIS_HOST,
        port: process.env.REDIS_PORT,
      },
    });
    subClient = pubClient.duplicate();

    //Redis DB Setting
    pubClient.on("error", (err) => console.log("Redis Client Error", err));
    pubClient.on("connect", () => console.log("Pub Connected to Redis"));
    subClient.on("connect", () => console.log("Sub Connected to Redis"));

    // DB,redis Connections
    Promise.all([pubClient.connect(), subClient.connect()]).then(() => {
      socketController.init(server, pubClient, subClient);
    });
  },
  set: async (key, value) => {
    try {
      if (!pubClient) {
        throw new Error("Redis client is not initialized");
      }
      await pubClient.set(String(key), JSON.stringify(value), {
        EX: 36000,
        NX: true,
      });
    } catch (e) {
      console.log(e);
    }
  },
  get: async (key) => {
    try {
      if (!pubClient) {
        throw new Error("Redis client is not initialized");
      }
      const value = await pubClient.get(String(key));
      if (value == null) {
        return false;
      }
      return value;
    } catch (e) {
      console.log(e);
    }
  },
  setJson: async (key, path, list_value) => {
    try {
      if (!pubClient) {
        throw new Error("Redis client is not initialized");
      }
      if (
        list_value == null ||
        list_value.length == undefined ||
        list_value.length == 0
      ) {
        console.log("Invalid List Or Empty Products");
      } else {
        await pubClient.json.set(key, path, list_value);
      }
    } catch (e) {
      console.log(e);
    }
  },
  addJson: async (key, value) => {
    try {
      if (!pubClient) {
        throw new Error("Redis client is not initialized");
      }
      await pubClient.json.arrAppend(key, "$", value);
    } catch (e) {
      console.log(e);
    }
  },
  getJson: async (key) => {
    try {
      if (!pubClient) {
        throw new Error("Redis client is not initialized");
      }

      let jsonProducts = await pubClient.json.get(key, "$");
      return jsonProducts;
    } catch (e) {
      console.log(e);
    }
  },
};
