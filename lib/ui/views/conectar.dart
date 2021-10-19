
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

  var result;
  var rest;


  openMetaMesk() async {
    const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
    try {
      await platform.invokeMethod('initWalletConnection', null);
      print('Connected....');
    } on PlatformException catch (e) {
      print("Failed to initWalletConnection: '${e.message}'.");
    }
  }

  keyMetaMask() async {
  const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
  try {
    result = await platform.invokeMethod('keyApproved', null);
  } on PlatformException catch (e) {
    print("Failed to initWalletConnection: '${e.message}'.");
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('key', result);
  rest = prefs.getString('key') ?? '';

  print(rest);
}
