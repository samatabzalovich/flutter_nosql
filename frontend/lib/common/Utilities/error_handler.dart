import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      showSnackBar(context: context, content: jsonDecode(response.body));
      break;
    case 500:
      showSnackBar(context: context, content: jsonDecode(response.body));
      break;
    default:
      showSnackBar(context: context, content: jsonDecode(response.body));
  }
}

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}