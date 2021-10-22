import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/controllers/home/collections/collections_controller.dart';

final collectionsProvider = StateNotifierProvider(
      (ref) => CollectionsController(),
);