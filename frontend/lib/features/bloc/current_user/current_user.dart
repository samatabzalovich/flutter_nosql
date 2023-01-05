import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/common/Utilities/error_handler.dart';
import 'package:store/models/user.dart';

final currentUserProvider = ChangeNotifierProvider<CurrentUserData>((ref) {
  return CurrentUserData();
});

class CurrentUserData extends ChangeNotifier {
  UserModel? _currentUser;
  bool get isSignedIn {
    return _currentUser != null;
  }

  UserModel get currentUser {
    return _currentUser!;
  }

  void setUser(UserModel user, BuildContext context) async {
    _currentUser = user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = user.token!;
    bool res = await prefs.setString('x-auth-token', token);
    if (res) {
      showSnackBar(context: context, content: 'User is saved');
    }
    notifyListeners();
  }

  Future<bool> signOut() async {
    // update state
    _currentUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.remove('x-auth-token');

    // and notify any listeners
    notifyListeners();
    return res;
  }
}
