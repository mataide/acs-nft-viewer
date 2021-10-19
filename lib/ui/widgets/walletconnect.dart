
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletConnect extends StatelessWidget {
/// Initialize NetworkStreamWidget with [key].
const WalletConnect({Key? key}) : super(key: key);
static const String EVENT_CHANNEL_WALLET = "com.bimsina.re_walls/WalletStreamHandler";
final _eventChannel = const EventChannel(EVENT_CHANNEL_WALLET);

@override
Widget build(BuildContext context){

  final networkStream = _eventChannel
      .receiveBroadcastStream()
      .distinct()
      .map((dynamic event) => event as String);

  return StreamBuilder<String>(
    initialData: "disconnected",
    stream: networkStream,
    builder: (context, snapshot) {
      print(snapshot.data);
      final address = snapshot.data ?? "unknown";
      print(address);
      return Container();
    }
  );
}
}

