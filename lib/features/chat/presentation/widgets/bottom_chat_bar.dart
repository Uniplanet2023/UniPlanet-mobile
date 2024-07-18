import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/features/chat/presentation/blocs/message/message_bloc.dart';

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
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.removeListener(_handleTextChange);
    _messageController.dispose();
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      getIt<MessageBloc>().add(SendTextMessageEvent(
          chatId: widget.chatRoomId,
          message: _messageController.text,
          receiverId: widget.sellerId,
          context: context));

      // Check if the widget is still mounted before updating the state
      if (!mounted) return;
      _messageController.clear();
      setState(() {
        isShowSendButton = false;
      });
      widget.scrollDownfuction();
    }
  }

  void sendImages(List<XFile> imageList) async {
    if (imageList.isNotEmpty) {
      getIt<MessageBloc>().add(SendImageMessageEvent(
        images: imageList,
        chatId: widget.chatRoomId,
        receiverId: widget.sellerId,
      ));

      widget.scrollDownfuction();
    }
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void _handleTextChange() {
    // Update the send button visibility
    setState(() {
      isShowSendButton = _messageController.text.isNotEmpty;
    });

    // Prevent text from expanding beyond 4 lines
    int newlineCount = '\n'.allMatches(_messageController.text).length;
    if (newlineCount >= 4) {
      // Truncate text to stop at the fourth line
      List<String> lines = _messageController.text.split('\n');
      if (lines.length > 4) {
        String truncatedText = lines.sublist(0, 4).join('\n');
        _messageController.text = truncatedText; // Set truncated text
        _messageController.selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length),
        ); // Set cursor at the end of the text
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _messageController,
                  keyboardType:
                      TextInputType.multiline, // Enable multiline input
                  minLines: 1,
                  maxLines: 4, // No limit on the number of lines
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      Initialization.socketService
                          .sendTypingEvent(widget.chatRoomId);
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
                    Initialization.socketService
                        .sendStopTypingEvent(widget.chatRoomId);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    prefixIcon: SizedBox(
                      width: 30,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () async {
                              File? image = await openCamera(context);
                              if (image == null) return;
                              sendImages([XFile(image.path)]);
                            },
                            padding: const EdgeInsets.all(0),
                            color:
                                Theme.of(context).colorScheme.primaryFixedDim,
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Type a message!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 5), // Reduced content padding
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.photo_size_select_actual_outlined),
                onPressed: () async {
                  List<XFile> imageList = await pickImagesFromGallery(context);
                  sendImages(imageList);
                },
                color: Theme.of(context).colorScheme.tertiary,
                padding: const EdgeInsets.all(0),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 0,
                  right: 5,
                  left: 2,
                ),
                child: !isShowSendButton
                    ? const SizedBox()
                    : CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 15,
                        child: GestureDetector(
                            onTap: () => sendTextMessage(),
                            child: const Icon(
                              Icons.arrow_upward_sharp,
                              color: Colors.white,
                            )),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
