import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:faktura_nft_viewer/app/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';

// Providers
import 'package:faktura_nft_viewer/core/providers/providers.dart';

import 'controllers/home/settings/settings_login_controller.dart';


SharedPreferences? prefs;
SharedPreferences? preferences;

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((shared) {
    prefs = shared;
    runApp(ProviderScope(child: MyApp()));
    });

}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themesNotifier = ref.read(themeProvider.notifier);
    themesNotifier.setTheme(themes[prefs!.getInt("theme") ?? 1]);
    //sharedPrefs.init();

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
