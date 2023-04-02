// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_clone/constants/GlobalVars.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/features/account/widgets/buttom_bar.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signupUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        address: '',
        email: email,
        name: name,
        password: password,
        id: '',
        token: '',
        role: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: {'Content-Type': 'application/json'},
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Account created! login with the same info')));
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void signinUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: '',
        email: email,
        password: password,
        address: '',
        role: '',
        token: '',
        cart: [],
      );
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: user.toJson(),
        headers: {'Content-Type': 'application/json'},
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth-token', jsonDecode(res.body)['token']);
          if (!context.mounted) return;
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          String role =
              Provider.of<UserProvider>(context, listen: false).user.role;
          Navigator.pushNamed(context,
              role == 'admin' ? AdminScreen.routeName : BottomBar.routeName);
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void getUserData({required BuildContext context}) async {
    print('get user datat');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth-token');
    //String token = '';
    if (token != null) {
      http.Response res = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: {
          'Content-Type': 'application/json',
          'auth-token': token,
        },
      );
      //for token verififcation the server is going to return true or false
      if (jsonDecode(res.body) == true) {
        http.Response userDataRes =
            await http.get(Uri.parse('$uri/userData'), headers: {
          'Content-Type': 'application/json',
          'auth-token': token,
        });
        Provider.of<UserProvider>(context, listen: false)
            .setUser(userDataRes.body);
      }
    }
  }

  void logout({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('auth-token');
    Provider.of<UserProvider>(context, listen: false).removeUser();
    Navigator.pushNamed(context, AuthScreen.routeName);
  }
}
