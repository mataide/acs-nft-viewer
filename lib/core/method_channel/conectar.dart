
import 'package:flutter/services.dart';


  openMetaMesk() async {
    const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
    try {
      await platform.invokeMethod('initWalletConnection', null);

    } on PlatformException catch (e) {
      print("Failed to initWalletConnection: '${e.message}'.");
    }

  }

