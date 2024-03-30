import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/network/socket/socket_channel.dart';

class BottomChatField extends StatefulWidget {
  final String chatRoomId;
  final Function scrollDownfuction;
  final String sellerId;
  const BottomChatField({
    super.key,
    required this.chatRoomId,
    required this.scrollDownfuction,
    required this.sellerId,
  });

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isContainerVisible = false;
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  // FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // _soundRecorder = FlutterSoundRecorder();
    focusNode.addListener(() {
      if (focusNode.hasFocus && isContainerVisible) {
        // If TextFormField is clicked and container is visible
        setState(() {
          isContainerVisible = false; // Hide the container
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    // _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void openAudio() async {
    // final status = await Permission.microphone.request();
    // if (status != PermissionStatus.granted) {
    //   throw RecordingPermissionException('Mic permission not allowed!');
    // }
    // await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      SocketService.instance.sendMessage(_messageController.text,
          widget.chatRoomId, 'text', widget.sellerId, context);
      _messageController.clear();
      widget.scrollDownfuction();
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    // ref.read(chatControllerProvider).sendFileMessage(
    //       context,
    //       file,
    //       widget.recieverUserId,
    //       messageEnum,
    //       widget.isGroupChat,
    //     );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async {
    // final gif = await pickGIF(context);
    // if (gif != null) {
    //   ref.read(chatControllerProvider).sendGIFMessage(
    //         context,
    //         gif.url,
    //         widget.recieverUserId,
    //         widget.isGroupChat,
    //       );
    // }
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _messageController,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      SocketService.instance
                          .sendTypingEvent(widget.chatRoomId, context);
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
                  },
                  onEditingComplete: () => sendTextMessage(),
                  onTapOutside: (_) {
                    SocketService.instance
                        .sendStopTypingEvent(widget.chatRoomId, context);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: GlobalVariables.backgroundColor,
                    prefixIcon: SizedBox(
                      width: 50,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isContainerVisible =
                                    !isContainerVisible; // Toggle container visibility
                              });
                              if (isContainerVisible) {
                                hideKeyboard(); // Hide the keyboard if container is shown
                              } else {
                                showKeyboard(); // Show the keyboard if container is hidden
                              }
                            },
                            icon: Transform.rotate(
                                angle: isContainerVisible ? 0.785398 : 0,
                                child: const Icon(
                                  Icons
                                      .add, // Change icon based on container visibility
                                  color: Colors.grey,
                                )),
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
                padding: const EdgeInsets.only(
                  bottom: 0,
                  right: 2,
                  left: 2,
                ),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF128C7E),
                  radius: 20,
                  child: GestureDetector(
                    onTap: () => sendTextMessage(),
                    child: Icon(
                      isShowSendButton
                          ? Icons.send
                          : isRecording
                              ? Icons.close
                              : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Conditionally render the new container based on the value of isContainerVisible
          AnimatedContainer(
            duration: const Duration(milliseconds: 20),
            height: isContainerVisible ? 200 : 0,
            color: Colors.grey[200],
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: () => pickImageFromGallery(context),
                    color: Colors.blue,
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => openCamera(),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
