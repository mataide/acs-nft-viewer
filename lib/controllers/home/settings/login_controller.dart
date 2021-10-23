
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  final String? rest;


  Login({
    this.rest,
  });
}

class LoginController extends StateNotifier<Login> {
  LoginController([Login? state]) : super(Login()) {
    sharedRead(rest);
    sharedRemove(rest);
  }

  get rest => Login().rest;


  Future sharedWrite(val) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('key', val);
    state = Login(rest: val);
  }


  Future sharedRead(rest) async {
    final preferences = await SharedPreferences.getInstance();
    final rest = preferences.getString('key');
    state = Login(rest: rest);
  }

  Future sharedRemove(rest) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove('key');
    rest = null;
    state = Login(rest: rest);
  }

}
