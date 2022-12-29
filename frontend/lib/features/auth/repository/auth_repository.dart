import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:store/features/auth/otp_screen/otp_screen.dart';
import 'package:store/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/Utilities/error_handler.dart';
class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  String uri = 'http://192.168.1.71:5000';
  AuthRepository(this.auth, this.firestore);
    Future<String?> signUpWithEmail(BuildContext context, String phoneNumber,
      String name, String password) async {
    try {
      final reqBody = <String, String>{
        "name": name,
        "phoneNumber": phoneNumber,
        "password": password
      };
      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(reqBody));
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
              context: context,
              content: 'Account created and verify your number');
        },
      );
      return res.body;
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return null;
  }
  void getCurrentUsersData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/user-data'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        // var userProvider = ref.read(currentUserProvider);
        // userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(content: e.toString(), context: context);
    }
  }


  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          verificationCompleted: (PhoneAuthCredential credential) async =>
              await auth.signInWithCredential(credential),
          verificationFailed: (e) => throw Exception(e.message),
          codeSent: ((verificationId, forceResendingToken) =>
              Navigator.pushNamed(context, OTPScreen.routeName,
                  arguments: verificationId)),
          codeAutoRetrievalTimeout: ((verificationId) {}));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }
}
