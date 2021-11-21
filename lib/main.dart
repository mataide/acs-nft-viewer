import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:faktura_nft_viewer/app/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';

// Providers
import 'package:faktura_nft_viewer/core/providers/providers.dart';

import 'app/home/settings/settings_login.dart';

SharedPreferences? prefs;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((shared) {
    prefs = shared;
    runApp(ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final themesNotifier = watch(themeProvider.notifier);
    themesNotifier.setTheme(themes[prefs!.getInt("theme") ?? 1]);

    return MaterialApp(
      theme: themesNotifier.getTheme(),
      title: 'reWalls',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
      },
      home: HomePage(),
    );
  }
}
