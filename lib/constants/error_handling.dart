import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/constants/utils.dart';

void httpErrorHandle({
  required Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      SnackbarGlobal.showSnackBar(jsonDecode(response.data)['msg']);
      break;
    case 500:
      SnackbarGlobal.showSnackBar(jsonDecode(response.data)['error']);
      break;
    default:
      SnackbarGlobal.showSnackBar(response.data);
  }
}
