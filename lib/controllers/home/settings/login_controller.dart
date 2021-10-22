import 'dart:async';
import 'package:NFT_View/app/home/settings/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  final String rest;
  Login({this.rest = ""});
}

class LoginController extends StateNotifier<Login> {
  LoginController(Login state) : super(state);

  Future<void> sharedWrite(rest) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('key', rest);
  }

  Future<void> sharedRead(String rest) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rest = prefs.getString('key')!;
  }

  Future<void> sharedRemove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('key');
  }
}
