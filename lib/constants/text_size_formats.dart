import 'package:flutter/material.dart';
import 'package:uniplanet/common/widgets/selectable_text.dart';

Widget titleText(String title,
    {Color color = Colors.black, TextAlign textAlign = TextAlign.start}) {
  return Text(
    title,
    textAlign: textAlign,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 25,
      color: color,
    ),
  );
}

Widget subTitleText(String title,
    {Color color = Colors.black, TextAlign textAlign = TextAlign.start}) {
  return Text(
    title,
    textAlign: textAlign,
    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: color),
  );
}

Widget secondarySubTitleText(String title,
    {Color color = Colors.black, TextAlign textAlign = TextAlign.start}) {
  return Text(
    title,
    textAlign: textAlign,
    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: color),
  );
}

Widget content(String title,
    {Color color = Colors.black, TextAlign textAlign = TextAlign.start}) {
  return SelectableLinkText(
    text: title,
    fontSize: 14,
  );
}
