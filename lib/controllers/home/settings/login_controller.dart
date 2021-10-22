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
    sharedWrite();
    sharedRemove();
  }

  get rest => Login().rest;

  sharedWrite() async {
    final _rest = rest;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('key', _rest);
      sharedRead();
      state = Login(rest: _rest);
    });
  }

  sharedRead() async {
    SharedPreferences.getInstance().then((prefs) {
      final _rest = prefs.getString('key');
      state = Login(rest: _rest);
    });
  }

  sharedRemove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('key');
  }
}
