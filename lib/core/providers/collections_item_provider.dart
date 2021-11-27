import 'package:faktura_nft_viewer/controllers/home/collections/collections_item_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

collectionsItemProvider(collections) {
  return StateNotifierProvider<CollectionsItemController, CollectionsItemState>(
    (ref) => CollectionsItemController(collections),
  );
}