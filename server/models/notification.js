const mongoose = require("mongoose");

const notificationSchema = mongoose.Schema({
  noticeMessages: {
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    message: {
      type: String,
      required: true,
    },
    timestamp: {
      type: Date,
      default: Date.now,
    },
  },
});
const Notification = mongoose.model("Notification", notificationSchema);
// Watch the Notification collection
Notification.watch().on("change", async (change) => {
  if (
    change.operationType === "insert" &&
    change.fullDocument &&
    change.fullDocument._id
  ) {
    const notificationId = change.fullDocument._id;

    // Update all users' unseenNotifications array
    try {
      await User.updateMany(
        {},
        {
          $push: {
            unseenNotifications: notificationId,
          },
        }
      );
    } catch (err) {
      console.error("Error updating all users' unseenNotifications:", err);
    }
  }
});

module.exports = Notification;
