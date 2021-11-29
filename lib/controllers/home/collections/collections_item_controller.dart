import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/database_helper/database.dart';

class CollectionsItemState {
  final Collections collections;
  final kdataFetchState fetchState;
  final List<CollectionsItem> collectionsItemList;

  const CollectionsItemState(this.collections, {this.fetchState = kdataFetchState.IS_LOADING, this.collectionsItemList = const []});
}

class CollectionsItemController extends StateNotifier<CollectionsItemState> {
  CollectionsItemController(Collections collections) : super(CollectionsItemState(collections));

  Future<List<CollectionsItem>> prepareFromDb() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsItemDAO = database.collectionsItemDAO;
    final List<CollectionsItem> collectionsItem = await collectionsItemDAO.findCollectionsItemByAddress(state.collections.contractAddress);
    state = CollectionsItemState(state.collections, collectionsItemList: collectionsItem);
    return collectionsItem;
  }

  Future<List<CollectionsItem>> prepareFromInternet(Collections collections) async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsItemDAO = database.collectionsItemDAO;
    final List<CollectionsItem> collectionsItem = await collectionsItemDAO.findCollectionsItemByAddress(collections.contractAddress);

    state = CollectionsItemState(state.collections, collectionsItemList: collectionsItem);
    return collectionsItem;
  }
}
