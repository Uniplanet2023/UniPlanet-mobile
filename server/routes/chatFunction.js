const ChatRoom = require("../models/chat_room");
const User = require("../models/user");
async function creatingChatRoom(userId, receiverId) {
  try {
    console.log(
      "\x1b[32m----------------- ChatRoom API : Creating ChatRoom API is Triggered -----------------\x1b[0m"
    );

    if (!receiverId) {
      throw new Error("receiverId are required");
    }
    console.log("1. Cheking UserID and ReceiverID");
    if (userId == receiverId) {
      console.log("2. Cheking UserID and ReceiverID are Same!");
      return;
    }
    // Check if a chat room already exists between the user and the receiver
    console.log("2. Checking the chatroom is already existed");

    let existingChatRoom = await ChatRoom.findOne({
      buyer: userId,
      seller: receiverId,
    }).populate("seller buyer lastMessage");

    if (existingChatRoom) {
      console.log(
        "3. Existing Room : Determine if req.user is the buyer or seller"
      );
      console.log(
        "\x1b[32m----------------- ChatRoom API : Creating ChatRoom API is scuessfully completed -----------------\x1b[0m"
      );
      return existingChatRoom;
    } else {
      console.log("3. Creating Room Model");

      let chatRoom = new ChatRoom({
        buyer: userId,
        seller: receiverId,
        chatRoomType: "resell",
      });
      console.log("4. Save ChatRoom into DB");
      Promise.all([
        await chatRoom.save(),
        await User.findByIdAndUpdate(
          userId,
          { $push: { chatRooms: chatRoom._id } },
          { new: true, useFindAndModify: false }
        ),

        // Update the seller's chatRooms field
        await User.findByIdAndUpdate(
          receiverId,
          { $push: { chatRooms: chatRoom._id } },
          { new: true, useFindAndModify: false }
        ),
        console.log("5. Setting User as Buyer"),
        // Populate the seller details
        await chatRoom.populate("seller buyer"),
      ]);

      console.log(
        "\x1b[32m----------------- ChatRoom API : Creating ChatRoom API is scuessfully completed -----------------\x1b[0m"
      );

      return chatRoom;
    }
  } catch (error) {
    console.log(
      "\x1b[31m----------------- There is an error in Creating ChatRoom API -----------------\x1b[0m"
    );
    console.error(error);
  }
}
module.exports = creatingChatRoom;
1;
