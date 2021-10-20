
import 'package:NFT_View/app/widgets/walletconnect.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

  var result;
  var rest;

  openMetaMesk() async {
    const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
    try {
      await platform.invokeMethod('initWalletConnection', null);

    } on PlatformException catch (e) {
      print("Failed to initWalletConnection: '${e.message}'.");
    }

  }

  keyMetaMask() async {
    // final networkStream = _eventChannel
    //     .receiveBroadcastStream()
    //     .distinct()
    //     .map((dynamic event) async {
    //
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     prefs.setString('key', event as String);
    //     rest = prefs.getString('key') ?? '';
    //  });

    //       .map((dynamic event) => event as String);
  // const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
  // try {
  //   result = await platform.invokeMethod('keyApproved', null);
  // } on PlatformException catch (e) {
  //   print("Failed to initWalletConnection: '${e.message}'.");
  // }


  //print(rest);
}
