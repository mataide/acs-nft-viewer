import 'dart:async';
import 'package:NFT_View/app/home/settings/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final String rest;

class ConstantsKey extends LoginPage {
  Future<void> sharedWrite() async {
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
