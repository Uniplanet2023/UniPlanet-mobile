import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectableLinkText extends StatelessWidget {
  const SelectableLinkText({
    super.key,
    required this.text,
    this.onTap,
    this.style,
    this.maxLines,
    this.minLines,
    this.fontSize,
  });
  final int? maxLines;
  final int? minLines;
  final String text;
  final VoidCallback? onTap;
  final TextStyle? style;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return SelectableLinkify(
      contextMenuBuilder: (context, editableTextState) {
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: <ContextMenuButtonItem>[
            ContextMenuButtonItem(
              onPressed: () {
                editableTextState.copySelection(SelectionChangedCause.toolbar);
              },
              type: ContextMenuButtonType.copy,
            ),
            ContextMenuButtonItem(
              onPressed: () {
                editableTextState.selectAll(SelectionChangedCause.toolbar);
              },
              type: ContextMenuButtonType.selectAll,
            ),
          ],
        );
      },
      onOpen: (link) async {
        if (!await launchUrl(Uri.parse(link.url))) {
          throw Exception('Could not launch ${link.url}');
        }
      },
      text: text,
      minLines: minLines,
      maxLines: maxLines,
      style: TextStyle(fontSize: fontSize ?? 16, color: Colors.black),
      linkStyle: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
        decorationColor: Colors.blue, // Set underline color
        decorationStyle: TextDecorationStyle.solid,
      ),
    );
  }
}
