import 'package:amazon_clone/models/user.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    role: '',
    token: '',
    cart: [],
  );
  User get user => _user;
  double subTotal = 0;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserModel(User user) {
    _user = user;
    notifyListeners();
  }

  void removeUser() {
    _user = User(
      id: '',
      name: '',
      email: '',
      password: '',
      address: '',
      role: '',
      token: '',
      cart: [],
    );
    notifyListeners();
  }

  void setCartSubtotal() {
    double sum = 0;
    _user.cart
        .map((item) => sum += item['quantity'] * item['product']['price'])
        .toList();
    subTotal = sum;
    //notifyListeners();
  }
}
