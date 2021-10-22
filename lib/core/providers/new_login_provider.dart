import 'package:NFT_View/core/utils/login_shared.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/core/utils/constants_key.dart';

final keyNotifierProvider = StateNotifierProvider(
  (ref) => KeyNotifier(rest),
);
