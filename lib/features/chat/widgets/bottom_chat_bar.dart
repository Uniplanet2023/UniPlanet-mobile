import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class BottomChatField extends StatefulWidget {
  final String recieverId;
  const BottomChatField({
    super.key,
    required this.recieverId,
  });

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;
  bool isRecording = false;
  final TextEditingController _messageController = TextEditingController();
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  User user = UserRepository().getUser;
  void createRepository(context) async {}
  void sendTextMessage(context) async {
    ChatRepository().sendMessage(
        context: context,
        msg: _messageController.text,
        receiverId: widget.recieverId);
    if (isShowSendButton) {
      // context.read(chatControllerProvider).sendTextMessage(
      //       context,
      //       _messageController.text.trim(),
      //       widget.recieverUserId,
      //       widget.isGroupChat,
      //     );
      setState(() {
        _messageController.text = '';
      });
    } else {
      // var tempDir = await getTemporaryDirectory();
      // var path = '${tempDir.path}/flutter_sound.aac';
      // if (!isRecorderInit) {
      //   return;
      // }
    }
  }

// void selectImage() async {
//     File? image = await pickImageFromGallery(context);
//     if (image != null) {
//       sendFileMessage(image, MessageEnum.image);
//     }
//   }

//   void selectVideo() async {
//     File? video = await pickVideoFromGallery(context);
//     if (video != null) {
//       sendFileMessage(video, MessageEnum.video);
//     }
//   }
  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();
  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            focusNode: focusNode,
            controller: _messageController,
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              } else {
                setState(() {
                  isShowSendButton = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: GlobalVariables.greyBackgroundCOlor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: 48,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: toggleEmojiKeyboardContainer,
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0, right: 8, left: 2),
          child: CircleAvatar(
            backgroundColor: GlobalVariables.primaryColor,
            radius: 25,
            child: GestureDetector(
              onTap: () => sendTextMessage(context),
              child: Icon(
                isShowSendButton
                    ? Icons.send
                    : isRecording
                        ? Icons.close
                        : Icons.mic,
              ),
            ),
          ),
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });

                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  }),
                ),
              )
            : const SizedBox(
                height: 100,
              ),
      ],
    );
  }
}
