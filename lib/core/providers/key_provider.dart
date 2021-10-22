import 'package:NFT_View/core/utils/key_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final keyProvider = StateNotifierProvider(
  (ref) => KeyNotifier(),
);
