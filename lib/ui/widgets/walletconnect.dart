
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletConnect extends StatelessWidget {
/// Initialize NetworkStreamWidget with [key].
const WalletConnect({Key? key}) : super(key: key);
static const String EVENT_CHANNEL_WALLET = "com.bimsina.re_walls/WalletStreamHandler";
final _eventChannel = const EventChannel(EVENT_CHANNEL_WALLET);

@override
Widget build(BuildContext context) {
  final networkStream = _eventChannel
      .receiveBroadcastStream()
      .distinct()
      .map((dynamic event) => event as String);

  return StreamBuilder<String>(
    initialData: "disconnected",
    stream: networkStream,
    builder: (context, snapshot) {
      final address = snapshot.data ?? "unknown";
      return _NetworkStateWidget(message: address, color: Colors.black);
    },
  );
}
}

class _NetworkStateWidget extends StatelessWidget {
  final String message;
  final Color color;

  const _NetworkStateWidget({required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: color,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      duration: kThemeAnimationDuration,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}