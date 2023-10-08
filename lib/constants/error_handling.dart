import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uniplanet_mobile/constants/utils.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      SnackbarGlobal.showSnackBar(jsonDecode(response.body)['msg']);
      break;
    case 500:
      SnackbarGlobal.showSnackBar(jsonDecode(response.body)['error']);
      break;
    default:
      SnackbarGlobal.showSnackBar(response.body);
  }
}
