import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/models/user.dart';

final currentUserProvider = ChangeNotifierProvider<CurrentUserData>((ref) {
  return CurrentUserData();
});

class CurrentUserData extends ChangeNotifier {
  UserModel? _currentUser;
  bool get isSignedIn {
    return _currentUser != null;
  }

  void setUser(firstName, lastName, phoneNumber, address, email, password, id) {
    _currentUser = UserModel(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
        email: email,
        password: password, id: id);
    notifyListeners();
  }
  void signOut()  {
    // update state
    _currentUser = null;
    // and notify any listeners
    notifyListeners();
  }
}
