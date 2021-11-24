import 'package:faktura_nft_viewer/controllers/home/search/wallpaper_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wallpaperProvider = StateNotifierProvider<WallPaperController, WallPaperState>(
      (ref) => WallPaperController(),
);
