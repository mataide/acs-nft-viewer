import 'package:faktura_nft_viewer/controllers/widgets/card_list_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

cardListProvider(collectionsItemList) {
  return StateNotifierProvider<CardListController, CardListState>(
        (ref) => CardListController(collectionsItemList),
  );
}