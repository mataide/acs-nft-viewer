import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/controllers/home/home_collections_controller.dart';

final homeCollectionsProvider = StateNotifierProvider(
      (ref) => HomeCollectionsController(),
);