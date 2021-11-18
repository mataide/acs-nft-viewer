import 'package:faktura_nft_viewer/controllers/home/collections/item/item_nft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemNftProvider = StateNotifierProvider(
      (ref) => ItemNftController(),
);
