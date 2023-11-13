const User = require("../models/user");
const UserChatRoom = require("../models/user_chat_room");
async function signInFunction(email) {
  return await User.findOne({ email }).populate({
    path: "myChatRoom",
    populate: [
      {
        path: "chatRoom",
        populate: [
          { path: "lastMessage" },
          {
            path: "product",
            populate: {
              path: "seller",
              select:
                "name email _id school verified profileImage like selling sold bought type",
            },
          },
        ],
      },
      {
        path: "receiver",
        select:
          "name email _id school verified profileImage like selling sold bought type",
      },
    ],
  });
}
async function getUserDataFunction(userId) {
  return await User.findById(userId).populate({
    path: "myChatRoom",
    populate: [
      {
        path: "chatRoom",
        populate: [
          { path: "lastMessage" },
          {
            path: "product",
            populate: {
              path: "seller",
              select:
                "name email _id school verified profileImage like selling sold bought type",
            },
          },
        ],
      },
      {
        path: "receiver",
        select:
          "name email _id school verified profileImage like selling sold bought type",
      },
    ],
  });
}

async function getMyChatRoomDataFunction(myChatRoomId) {
  return await UserChatRoom.findById(myChatRoomId).populate([
    {
      path: "chatRoom",
      populate: [
        { path: "lastMessage" },
        {
          path: "product",
          populate: {
            path: "seller",
            select:
              "name email _id school verified profileImage like selling sold bought type",
          },
        },
      ],
    },
    {
      path: "receiver",
      select:
        "name email _id school verified profileImage like selling sold bought type",
    },
  ]);
}

module.exports = {
  signInFunction,
  getUserDataFunction,
  getMyChatRoomDataFunction,
};
