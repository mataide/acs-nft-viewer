import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/controllers/home/settings/settings_login_controller.dart';

final loginProvider = StateNotifierProvider(
      (ref) => SettingsLoginController(),
);
