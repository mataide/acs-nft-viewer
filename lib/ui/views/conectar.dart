
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

  var result;
  var rest;
  const String EVENT_CHANNEL_WALLET = "com.bimsina.re_walls/WalletStreamHandler";
  final _eventChannel = const EventChannel(EVENT_CHANNEL_WALLET);

  openMetaMesk() async {
    const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
    try {
      await platform.invokeMethod('initWalletConnection', null);
      print('Connected....');
    } on PlatformException catch (e) {
      print("Failed to initWalletConnection: '${e.message}'.");
    }
    final networkStream = _eventChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('key', event as String);
      rest = prefs.getString('key') ?? '';
    });
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
