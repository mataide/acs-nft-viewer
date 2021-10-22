
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



//NÃO ESTÁ SENDO USADA.
class WalletConnect extends ConsumerWidget {
/// Initialize NetworkStreamWidget with [key].
const WalletConnect({Key? key}) : super(key: key);
static const String EVENT_CHANNEL_WALLET = "com.bimsina.re_walls/WalletStreamHandler";
final _eventChannel = const EventChannel(EVENT_CHANNEL_WALLET);

@override
Widget build(BuildContext context, ScopedReader watch) {

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
      return CircularProgressIndicator(
        backgroundColor: Colors.blueAccent,
      );
    }
  );
}
}

