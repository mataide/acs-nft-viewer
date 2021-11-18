import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/core/utils/theme_notifier.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';

final themeProvider = StateNotifierProvider(
      (ref) => ThemeNotifier(themes[1]),
);