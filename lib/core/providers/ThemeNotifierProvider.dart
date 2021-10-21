import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/core/utils/theme.dart';
import 'package:NFT_View/core/utils/constants.dart';

final themeNotifierProvider = StateNotifierProvider(
      (ref) => ThemeNotifier(themes[1]),
);