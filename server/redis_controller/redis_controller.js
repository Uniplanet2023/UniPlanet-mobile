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
      await pubClient.set(String(key), JSON.stringify(value));
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
  setLists: (key, list_value) => {
    try {
      if (!pubClient) {
        throw new Error("Redis client is not initialized");
      }
      if (
        list_value == null ||
        list_value.length == undefined ||
        list_value.length == 0
      ) {
        throw new Error("Invalid List");
      } else {
        for (let i = 0; i < list_value.length; i++) {
          pubClient.sAdd(key, JSON.stringify(list_value[i]));
        }
      }
    } catch (e) {
      console.log(e);
    }
  },
  addSet: async (key, value) => {
    try {
      if (!pubClient) {
        throw new Error("Redis client is not initialized");
      }

      await pubClient.sAdd(key, JSON.stringify(value));
    } catch (e) {
      console.log(e);
    }
  },
  getSubSets: async (key, category) => {
    try {
      //finding the sets from key, which category == $category
      if (!pubClient) {
        throw new Error("Redis client is not initialized");
      }
      // Get all members of the set
      let sets = await pubClient.SMEMBERS(key);
      let subset = sets.filter((item) => {
        let parseItem = JSON.parse(item);
        return parseItem.category && parseItem.category === category;
      });
      let list = subset.map((item) => JSON.parse(item));
      return list;
    } catch (e) {
      console.log(e);
    }
  },
  getSets: async (key) => {
    try {
      if (!pubClient) {
        throw new Error("Redis client is not initialized");
      }
      //Algorithm fix needed
      let sets = await pubClient.SMEMBERS(key);
      let list = [];
      for (let i = 0; i < sets.length; i++) {
        list.push(JSON.parse(sets[i]));
      }
      return list;
    } catch (e) {}
  },
};
