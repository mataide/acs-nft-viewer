import 'package:NFT_View/core/utils/constants_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletConnect extends StatelessWidget {
  /// Initialize NetworkStreamWidget with [key].
  const WalletConnect({Key? key}) : super(key: key);
  static const String EVENT_CHANNEL_WALLET =
      "com.bimsina.re_walls/WalletStreamHandler";
  final _eventChannel = const EventChannel(EVENT_CHANNEL_WALLET);

  @override
  Widget build(BuildContext context) {
    openMetaMesk();
    final networkStream = _eventChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => event as String);

    return StreamBuilder<String>(
        initialData: rest.toString(),
        stream: networkStream,
        builder: (context, snapshot) {
          rest = snapshot.data ?? "unknown";
          return CircularProgressIndicator(
            backgroundColor: Colors.blueAccent,
          );
        });
  }

  openMetaMesk() async {
    const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
    try {
      await platform.invokeMethod('initWalletConnection', null);
    } on PlatformException catch (e) {
      print("Failed to initWalletConnection: '${e.message}'.");
    }
  }
}
