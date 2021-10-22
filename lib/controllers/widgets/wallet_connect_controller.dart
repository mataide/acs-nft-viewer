import 'package:NFT_View/core/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

// Controllers
import 'package:NFT_View/controllers/home/settings/login_controller.dart';




class WalletConnect extends ConsumerWidget {
  /// Initialize NetworkStreamWidget with [key].
  const WalletConnect({Key? key}) : super(key: key);
  static const String EVENT_CHANNEL_WALLET = "com.bimsina.re_walls/WalletStreamHandler";
  final _eventChannel = const EventChannel(EVENT_CHANNEL_WALLET);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final key = watch(loginProvider.notifier);


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
          key.rest(address);
          return CircularProgressIndicator(
            backgroundColor: Colors.blueAccent,
          );
        }
    );
  }
}

  openMetaMesk() async {
    const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
    try {
      await platform.invokeMethod('initWalletConnection', null);
    } on PlatformException catch (e) {
      print("Failed to initWalletConnection: '${e.message}'.");
    }
  }

