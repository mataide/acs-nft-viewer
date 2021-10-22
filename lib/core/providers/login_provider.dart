import 'package:NFT_View/core/utils/login_shared.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/controllers/home/settings/login_controller.dart';

final loginProvider = StateNotifierProvider(
  (ref) => KeyNotifier(rest),
);
