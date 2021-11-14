import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/controllers/widgets/wallpaper_list_controller.dart';

final wallpaperListProvider = StateNotifierProvider(
      (ref) => WallpaperListController(),
);
