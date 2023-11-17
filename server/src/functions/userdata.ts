import User from '../models/user'; // Adjust the path according to your project structure
import UserChatRoom from '../models/user_chat_room';

async function signInFunction(email: string) {
  return await User.findOne({ email }).populate({
    path: 'myChatRoom',
    populate: [
      {
        path: 'chatRoom',
        populate: [
          { path: 'lastMessage' },
          {
            path: 'product',
            populate: {
              path: 'seller',
              select:
                'name email _id school verified profileImage like selling sold bought type',
            },
          },
        ],
      },
      {
        path: 'receiver',
        select:
          'name email _id school verified profileImage like selling sold bought type',
      },
    ],
  });
}
async function getUserDataFunction(userId: string) {
  return await User.findById(userId).populate({
    path: 'myChatRoom',
    populate: [
      {
        path: 'chatRoom',
        populate: [
          { path: 'lastMessage' },
          {
            path: 'product',
            populate: {
              path: 'seller',
              select:
                'name email _id school verified profileImage like selling sold bought type',
            },
          },
        ],
      },
      {
        path: 'receiver',
        select:
          'name email _id school verified profileImage like selling sold bought type',
      },
    ],
  });
}

async function getMyChatRoomDataFunction(myChatRoomId: string) {
  return await UserChatRoom.findById(myChatRoomId).populate([
    {
      path: 'chatRoom',
      populate: [
        { path: 'lastMessage' },
        {
          path: 'product',
          populate: {
            path: 'seller',
            select:
              'name email _id school verified profileImage like selling sold bought type',
          },
        },
      ],
    },
    {
      path: 'receiver',
      select:
        'name email _id school verified profileImage like selling sold bought type',
    },
  ]);
}

export { signInFunction, getUserDataFunction, getMyChatRoomDataFunction };
