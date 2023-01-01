import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:store/features/auth/otp_screen/otp_screen.dart';
import 'package:store/features/widgets/custom_page_transition.dart';
import 'package:store/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/Utilities/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth auth;
  String uri = 'http://192.168.1.71:5000';
  AuthRepository(this.auth);
  Future<String?> signUpWithPhoneNumber(
    BuildContext context,
    String phoneNumber,
    String firstName,
    String lastName,
    String password,
    String address,
  ) async {
    try {
      final reqBody = <String, String>{
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "password": password,
        "address": address,
      };
      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(reqBody));
      bool isOk = httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
              context: context,
              content: 'Account will be created after you verified number');
        },
      );
      if (isOk) {
        return res.body;
      }
      return null;
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

  void signInWithPhone(BuildContext context, String phoneNumber, UserModel user) async {
    try {
      await auth.verifyPhoneNumber(
          verificationCompleted: (PhoneAuthCredential credential) async =>
              await auth.signInWithCredential(credential),
          verificationFailed: (e) => throw Exception(e.message),
          codeSent: ((verificationId, forceResendingToken) =>
              Navigator.push(context, CustomScaleTransition(nextPageUrl: OTPScreen.routeName, nextPage: OTPScreen(verifictaionId: verificationId, phoneNumber: phoneNumber, userModel: user)))),
          codeAutoRetrievalTimeout: ((verificationId) {}));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }
}
