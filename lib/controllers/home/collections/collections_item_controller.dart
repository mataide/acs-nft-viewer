import 'package:faktura_nft_viewer/core/client/APIClient.dart';
import 'package:faktura_nft_viewer/core/models/eth721.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/database_helper/database.dart';
import "package:collection/collection.dart";

class CollectionsItemState {
  final Collections collections;
  final kdataFetchState fetchState;

  const CollectionsItemState(this.collections, {this.fetchState = kdataFetchState.IS_LOADING});
}

class CollectionsItemController extends StateNotifier<CollectionsItemState> {
  CollectionsItemController(Collections collections) : super(CollectionsItemState(collections));

  Future<List<Collections>> prepareFromDb() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsDAO = database.collectionsDAO;
    List<Collections> collections = await collectionsDAO.findAllCollections();

    if(collections.isEmpty) {
      final preferences = await SharedPreferences.getInstance();
      final listAddress = preferences.getStringList('key');
      if (listAddress == null) return await prepareFromInternet("0x2f8c6f2dae4b1fb3f357c63256fe0543b0bd42fb"); else {
        for(var i = 0; i < listAddress.length; i++) collections.addAll(await prepareFromInternet(listAddress[i]));
      }
    }
    return collections;
  }

  Future<List<Collections>> prepareFromInternet(String address) async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final eth721Dao = database.eth721DAO;
    final collectionsDAO = database.collectionsDAO;

    final List<Eth721> listERC721 = await APIService.instance.getERC721(address);
    eth721Dao.insertList(listERC721);
    var newMap = groupBy(listERC721, (Eth721 obj) => obj.contractAddress);
    late List<Collections> listCollections = [];
    for (var erc721 in newMap.entries) {
    final collections = Collections.fromEth721(erc721.value.first, erc721.value.length);
      listCollections.add(collections);
    }
    await collectionsDAO.insertList(listCollections);
    //state = CollectionsItemState(state.refreshController, collections: listCollections, fetchState: kdataFetchState.IS_LOADED);
    return listCollections;
  }
}
