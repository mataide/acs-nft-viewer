import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/core/utils/theme_notifier.dart';
import 'package:NFT_View/core/utils/constants.dart';

final themeProvider = StateNotifierProvider(
      (ref) => ThemeNotifier(themes[1]),
);