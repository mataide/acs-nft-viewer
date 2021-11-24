import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/core/utils/theme_notifier.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
      (ref) => ThemeNotifier(themes[1]),
);