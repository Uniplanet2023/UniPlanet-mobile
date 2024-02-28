import 'dart:convert';

import 'package:uniplanet_mobile/constants/utils.dart';

String displayErrorMessages(String responseBody) {
  // Decode the JSON response body
  final decoded = jsonDecode(responseBody);
  var message = "success";
  // Check if 'errors' key exists and is a list
  if (decoded is! List &&
      decoded.containsKey('errors') &&
      decoded['errors'] is List) {
    final errors = decoded['errors'] as List;

    // Iterate through each error in the 'errors' list
    for (var error in errors) {
      // Access the 'message' for each error
      if (error.containsKey('message')) {
        SnackbarGlobal.showSnackBar("${error['message']}");
        message = error['message'];

        // Check for field-specific errors under 'fields'
        if (error.containsKey('fields') && error['fields'] is Map) {
          final fields = error['fields'] as Map;

          // Iterate through each field to access its error list
          fields.forEach((field, fieldErrors) {
            if (fieldErrors is List) {
              // Print each field-specific error message
              for (var fieldError in fieldErrors) {
                SnackbarGlobal.showSnackBar("Field $field error: $fieldError");
              }
            }
          });
        }
      }
    }
  }
  return message;
}
