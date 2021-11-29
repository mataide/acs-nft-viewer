import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/controllers/widgets/wallpaper_list_controller.dart';

wallpaperListProvider(collectionsItemList) {
  return StateNotifierProvider<WallpaperListController, WallpaperListState>(
        (ref) => WallpaperListController(collectionsItemList),
  );
}