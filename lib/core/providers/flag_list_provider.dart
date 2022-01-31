import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/controllers/widgets/flag_list_controller.dart';

flagListProvider(collectionsList) {
  return StateNotifierProvider<FlagListController, FlagListState>(
        (ref) => FlagListController(collectionsList),
  );
}