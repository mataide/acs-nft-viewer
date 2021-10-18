
import 'package:flutter/services.dart';


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
    var result;
    try {
      result = await platform.invokeMethod('keyApproved', null);
      //print('Connected....');
    } on PlatformException catch (e) {
      print("Failed to initWalletConnection: '${e.message}'.");
    }
    print(result);

  }