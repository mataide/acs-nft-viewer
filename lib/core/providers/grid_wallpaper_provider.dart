import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/controllers/widgets/grid_wallpaper_controller.dart';

final gridWallpaperProvider = StateNotifierProvider(
      (ref) => GridWallpaperController(),
);