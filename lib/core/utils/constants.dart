import 'package:flutter/material.dart';

enum kdataFetchState { IS_LOADING, IS_LOADED, ERROR_ENCOUNTERED }

const Color lightThemePrimaryColor = Color(0xffFFFFFF);
const Color lightThemePrimaryColorDark = Color(0xffE5EBF0);
const Color lightThemeAccentColor = Color(0xff770955);
const Color lightThemeButtonColor = Color(0xff770955);
const Color lightThemeCardColor = Color(0xff212121);
const Color lightThemeSubtitleColor = Color(0xff838385);

const Color darkThemePrimaryColor = Color(0xff171919);
const Color darkThemePrimaryColorDark = Color(0xff2B2B2B);
const Color darkThemeAccentColor = Color(0xff770955);
const Color darkThemeButtonColor = Color(0xff770955);
const Color darkThemeCardColor = Color(0xffFFFFFF);
const Color darkThemeSubtitleColor = Color(0xff929294);

const Color amoledThemePrimaryColor = Color(0xff000000);
const Color amoledThemePrimaryColorDark = Color(0xff2B2B2B);
const Color amoledThemeAccentColor = Color(0xff770955);

final List<ThemeData> themes = [lightTheme, darkTheme];

const List<Color> cardColors = [
  Color(0xffadb6c6),
  Color(0xff963e63),
  Color(0xffe6a542),
  Color(0xff519b89),
  Color(0xffab8c67),
  Color(0xffde34a0),
  Color(0xff5a9def),
  Color(0xfff4663c),
  Color(0xffa9c95a),
];

final darkTheme = ThemeData(
  primaryColor: darkThemePrimaryColor,
  primaryColorDark: darkThemePrimaryColorDark,
  buttonColor: darkThemeButtonColor,
  accentColor: darkThemeAccentColor,
  cardColor: darkThemeCardColor,
  canvasColor: Colors.transparent,
  primaryIconTheme: IconThemeData(color: Colors.white),
  textTheme: TextTheme(
    headline4: TextStyle(
        fontFamily: 'FuturaPTMedium.otf',
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontSize: 16),
    headline5: TextStyle(
        fontFamily: 'FuturaPTBook.otf',
        fontWeight: FontWeight.w400,
        color: Colors.white,
        fontSize: 16),
    subtitle1: TextStyle(
        fontFamily: 'FuturaPTLight.otf',
        fontWeight: FontWeight.w400,
        color: darkThemeSubtitleColor,
        fontSize: 12),
    bodyText2: TextStyle(
        fontFamily: 'FuturaPTMedium.otf',
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontSize: 12),
    bodyText1: TextStyle(
        fontFamily: 'FuturaPTLight.otf',
        fontWeight: FontWeight.w400,
        color: Colors.white,
        fontSize: 12),
    subtitle2: TextStyle(
        fontFamily: 'FuturaPTBold.otf',
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 20),
    caption: TextStyle(
        fontFamily: 'FuturaPTBold.otf',
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 28),
  ),
);

final lightTheme = ThemeData(
  primaryColorDark: lightThemePrimaryColorDark,
  primaryColor: lightThemePrimaryColor,
  buttonColor: lightThemeButtonColor,
  accentColor: lightThemeAccentColor,
  cardColor: lightThemeCardColor,
  canvasColor: Colors.transparent,
  primaryIconTheme: IconThemeData(color: Colors.black),
  textTheme: TextTheme(
    headline4: TextStyle(
        fontFamily: 'FuturaPTMedium.otf',
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 16),
    headline5: TextStyle(
        fontFamily: 'FuturaPTBook.otf',
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontSize: 16),
    subtitle1: TextStyle(
        fontFamily: 'FuturaPTLight.otf',
        fontWeight: FontWeight.w400,
        color: lightThemeSubtitleColor,
        fontSize: 12),
    bodyText2: TextStyle(
        fontFamily: 'FuturaPTMedium.otf',
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontSize: 12),
    bodyText1: TextStyle(
        fontFamily: 'FuturaPTLight.otf',
        fontWeight: FontWeight.w400,
        color: Colors.black,
        fontSize: 12),
    subtitle2: TextStyle(
        fontFamily: 'FuturaPTBold.otf',
        fontWeight: FontWeight.w700,
        color: Colors.black,
        fontSize: 20),
    caption: TextStyle(
        fontFamily: 'FuturaPTBold.otf',
        fontWeight: FontWeight.w700,
        color: Colors.black,
        fontSize: 28),
  ),
);

const List<String> phoneResolutions = [
  "1080x1920",
  "750x1334",
  "2960x1440",
  "640x1136",
  "1440x2560",
  "640x960",
  "720x1280",
  "1920x1080",
  "800x1280",
  "480x800",
  "768x1280",
  "800x480",
  "828x1792",
  "854x480",
  "960x540",
  "1125x2436",
  "1242x2688",
  "1280x720",
  "2560x1440",
];

const List<String> initialSubredditsList = [
  'mobilewallpapers',
  'Amoledbackgrounds',
  'phonewallpapers',
  'Verticalwallpapers',
  'MinimalWallpaper',
  'wallpapers',
  'phonewallpaper',
  'AnimeWallpaper',
  'iWallpaper',
  'wallpaper',
  'iPhoneWallpapers',
  'WQHD_Wallpaper',
  'S10Wallpapers',
  'MobileWallpaper',
];
