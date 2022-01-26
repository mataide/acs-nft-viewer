import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:faktura_nft_viewer/app/home/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Providers
import 'package:faktura_nft_viewer/core/providers/providers.dart';

SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'Faktura',
      options: DefaultFirebaseOptions.currentPlatform,
    ).whenComplete(() {
      print("completedAppInitialize");
    });
  }

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

    return MaterialApp(
      theme: themesNotifier.getTheme(),
      title: 'Faktura',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
      },
      home: HomePage(),
    );
  }
}
