import 'package:NFT_View/core/client/APIClient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:NFT_View/app/home/home.dart';
import 'core/utils/constants.dart';

SharedPreferences? prefs;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((shared) {
    prefs = shared;
    runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
          ChangeNotifierProvider<ThemeNotifier>(
            create: (_) => ThemeNotifier(themes[prefs!.getInt('theme') ?? 1]),
          ),
          Provider<APIClient>(
            create: (_) => APIService.instance)
        ],
        child: MaterialApp(
        theme: themes[prefs!.getInt('theme') ?? 1],
        title: 'reWalls',
        debugShowCheckedModeBanner: false,
        routes: {
        '/home': (context) => HomePage(),
        },
        home: HomePage(),
        ),);
  }
}
