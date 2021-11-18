import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/controllers/widgets/wallpaper_list_controller.dart';

final wallpaperListProvider = StateNotifierProvider(
      (ref) => WallpaperListController(),
);
