import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/controllers/home/home_collections_controller.dart';

final homeCollectionsProvider = StateNotifierProvider(
      (ref) => HomeCollectionsController(),
);