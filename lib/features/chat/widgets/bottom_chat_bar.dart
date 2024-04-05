import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/common/enums/message_status_enum.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/global.dart';
import 'package:uniplanet_mobile/models/image_message.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/network/repository/auth_repository/auth_repo.dart';
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
      context.read<MessageBloc>().add(SendTextMessageEvent(
          chatId: widget.chatRoomId,
          message: _messageController.text,
          receiverId: widget.sellerId,
          context: context));
      _messageController.clear();
      widget.scrollDownfuction();
    }
  }

  void sendImages(List<XFile> imageList) async {
    List<Message> messages = [];
    for (var image in imageList) {
      // Generate a unique ID for the message
      String uniqueId = UniqueKey().toString();
      // Create a temporary message with the image path
      String imagePath = File(image.path).path;
      Message tempMessage = Message(
        id: uniqueId,
        chat: widget.chatRoomId,
        message: imagePath,
        status: MessageStatusEnum.sending.value,
        messageType: MessageEnum.image.value,
        sender: AuthRepository.userId!,
        receiver: widget.sellerId,
        createdAt: DateTime.now(),
      );
      // Add the temporary message to the list of messages
      messages.add(tempMessage);
      context
          .read<MessageBloc>()
          .add(SendingMessageEvent(tempMessage: tempMessage, context: context));
    }
    for (var tempMessage in messages) {
      try {
        Message? imageUploadedMessage = await uploadImage(tempMessage);
        if (imageUploadedMessage == null) {
          throw Exception('Image uploading failed');
        }
        Message sentMessage = await uploadMessage(imageUploadedMessage);
        SnackbarGlobal.key.currentContext!
            .read<MessageBloc>()
            .add(SentMessageEvent(sentMessage));
      } catch (e) {
        print(e);
      }
    }
    widget.scrollDownfuction();
  }

  void sendingMessage(Message tempMessage) {}

  Future<Message?> uploadImage(Message tempMessage) async {
    CloudinaryResponse? response;
    try {
      response = await Global.cloudinary
          .uploadFile(
        CloudinaryFile.fromFile(tempMessage.message,
            resourceType: CloudinaryResourceType.Image,
            folder: tempMessage.chat),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Image uploading timed out');
        },
      );

      // Check if the context is still mounted before proceeding
      if (response.secureUrl.isEmpty) throw Exception('Image uploading failed');
      tempMessage.message = response.secureUrl;
      return tempMessage;
    } catch (e) {
      tempMessage = tempMessage.copyWith(status: MessageStatusEnum.error.value);
      ImageMessage imageMessage = ImageMessage(
        filePath: tempMessage.message,
        message: tempMessage,
      );
      SocketService.imageMessagesToRetry.add(imageMessage);
      // Update the temporary message's status to error
      SnackbarGlobal.key.currentContext!
          .read<MessageBloc>()
          .add(ErrorMessageEvent(tempMessage));
      return null;
    }
  }

  Future<Message> uploadMessage(Message message) async {
    Message sentMessage = message;
    try {
      sentMessage = await SocketService.instance
          .sendMessage(
        id: message.id,
        message: message.message,
        chatId: message.chat,
        messageType: MessageEnum.image.value,
        receiver: message.receiver,
        context: context,
      )
          .timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('Message sending timed out');
        },
      );
    } catch (e) {
      SocketService.messagesToRetry.add(message);
    }
    return sentMessage;
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
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () async {
                              File? image = await openCamera();
                              sendImages([XFile(image!.path)]);
                            },
                            padding: const EdgeInsets.all(0),
                            color: Colors.blue,
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
              IconButton(
                icon: const Icon(Icons.photo_library),
                onPressed: () async {
                  List<XFile> imageList = await pickImagesFromGallery(context);
                  sendImages(imageList);
                },
                padding: const EdgeInsets.all(0),
                color: Colors.blue,
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
        ],
      ),
    );
  }
}
