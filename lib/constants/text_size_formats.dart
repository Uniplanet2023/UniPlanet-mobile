import 'package:flutter/material.dart';

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
    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: color),
  );
}

Widget secondarySubTitleText(String title,
    {Color color = Colors.black, TextAlign textAlign = TextAlign.start}) {
  return Text(
    title,
    textAlign: textAlign,
    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: color),
  );
}

Widget content(String title,
    {Color color = Colors.black, TextAlign textAlign = TextAlign.start}) {
  return Text(
    title,
    textAlign: textAlign,
    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: color),
  );
}
