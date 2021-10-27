import 'package:NFT_View/controllers/home/home_settings_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeSettingsProvider = StateNotifierProvider(
      (ref) => HomeSettingsController(),
);