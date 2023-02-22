import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/common/Utilities/error_handler.dart';
import 'package:store/features/home/repository/home_repository.dart';
import 'package:store/models/product.dart';
import 'package:store/models/user.dart';
import 'package:http/http.dart' as http;

import '../../../common/constants/routes.dart';

final currentUserProvider = ChangeNotifierProvider<CurrentUserData>((ref) {
  return CurrentUserData(ref);
});

class CurrentUserData extends ChangeNotifier {
  final ChangeNotifierProviderRef ref;
  UserModel? currentUser;

  CurrentUserData(this.ref);
  bool get isSignedIn {
    return currentUser != null;
  }


  void setUser(UserModel user, BuildContext context) async {
    currentUser = user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = user.token!;
    bool res = await prefs.setString('x-auth-token', token);
    notifyListeners();
  }

  Future<bool> signOut() async {
    // update state
    currentUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.remove('x-auth-token');

    // and notify any listeners
    notifyListeners();
    return res;
  }
}
