import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/features/auth/otp_screen/otp_screen.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/features/home/screens/home_screen.dart';
import 'package:store/features/widgets/custom_page_transition.dart';
import 'package:store/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/Utilities/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/constants/routes.dart';

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepository(FirebaseAuth.instance, ref));

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authRepositoryProvider);
  return authController.getCurrentUsersData();
});

class AuthRepository {
  final FirebaseAuth auth;
  final ProviderRef ref;
  AuthRepository(this.auth, this.ref);
  void verifyPhoneNumber(
      BuildContext context,
      String phoneNumber,
      String firstName,
      String lastName,
      String password,
      String address,
      String email) async {
    try {
      UserModel user = UserModel(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
        email: email,
        password: password,
        cart: [],
        token: '',
        type: 'user',
      );

      await auth.verifyPhoneNumber(
          phoneNumber: "+7 $phoneNumber",
          verificationCompleted: (PhoneAuthCredential credential) async =>
              await auth.signInWithCredential(credential),
          verificationFailed: (e) => throw Exception(e.message),
          codeSent: ((verificationId, forceResendingToken) => Navigator.push(
              context,
              CustomScaleTransition(
                  nextPageUrl: OTPScreen.routeName,
                  nextPage: OTPScreen(
                      verifictaionId: verificationId,
                      phoneNumber: phoneNumber,
                      userModel: user)))),
          codeAutoRetrievalTimeout: ((verificationId) {}));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  Future<String?> signUpWithPhoneNumber(
      BuildContext context, UserModel user) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: user.toJson());

      bool isOk = httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context: context, content: 'Acount created');
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

  Future<bool> signInUser({
    required BuildContext context,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      bool isOk = httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          UserModel user = UserModel.fromJson(res.body);
          ref.read(currentUserProvider).setUser(user, context);
          await prefs.setString('x-auth-token', user.token!);
        },
      );
      if (!isOk) {
        return false;
      }
      return true;
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return false;
    }
  }

  Future<UserModel?> getCurrentUsersData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('x-auth-token');

    if (token == null) {
      prefs.setString('x-auth-token', '');
      return null;
    }

    var tokenRes = await http.post(
      Uri.parse('$uri/tokenIsValid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
    );

    var response = jsonDecode(tokenRes.body);
    UserModel? res;
    if (response != false) {
      res = UserModel.fromJson(tokenRes.body);
    }
    return res;
  }
}
