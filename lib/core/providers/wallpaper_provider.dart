import 'package:NFT_View/controllers/home/search/wallpaper_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wallpaperProvider = StateNotifierProvider(
      (ref) => WallPaperController(),
);
