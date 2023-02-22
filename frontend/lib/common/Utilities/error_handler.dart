import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

bool httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      return true;
    case 400:
      showSnackBar(context: context, content: response.body);
      return false;
    case 500:
      showSnackBar(context: context, content: jsonDecode(response.body));
      return false;
    default:
      showSnackBar(context: context, content: 'Unexpected error');
      return false;
  }
}

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
