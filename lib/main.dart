import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:NFT_View/app/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/core/utils/constants.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

SharedPreferences? prefs;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((shared) {
    prefs = shared;
    runApp(ProviderScope(
    child: MyApp()));
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