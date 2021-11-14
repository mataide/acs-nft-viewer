import 'package:NFT_View/core/client/APIClient.dart';
import 'package:NFT_View/app/widgets/selector.dart';
import 'package:NFT_View/core/models/eth721.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:NFT_View/core/utils/constants.dart';
import 'package:NFT_View/core/models/index.dart';
import 'package:NFT_View/database_helper/database.dart';
import "package:collection/collection.dart";

class CollectionsState {
  final List<Collections?>? collections;
  final kdataFetchState fetchState;
  final int? selectedFilter;

  const CollectionsState({this.fetchState = kdataFetchState.IS_LOADING, this.collections, this.selectedFilter});
}

class HomeCollectionsController extends StateNotifier<CollectionsState> {
  HomeCollectionsController([Collections? state]) : super(CollectionsState()) {
    prepareFromInternet();
  }

  get fetchState => state.fetchState;
  get selectedFilter => state.selectedFilter;
  get collections => state.collections;

  Future<List<Collections>> prepareFromDb() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsDAO = database.collectionsDAO;
    return await collectionsDAO.findAll();
  }

  void prepareFromInternet() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final eth721Dao = database.eth721DAO;
    final collectionsDAO = database.collectionsDAO;

    final List<Eth721> listERC721 = await APIService.instance.getERC721("0x2f8c6f2dae4b1fb3f357c63256fe0543b0bd42fb");
    eth721Dao.insertList(listERC721);
    var newMap = groupBy(listERC721, (Eth721 obj) => obj.contractAddress);
    late List<Collections> listCollections = [];
    for (var erc721 in newMap.entries) {
    final collections = Collections.fromEth721(erc721.value.first, erc721.value.length);
      listCollections.add(collections);
    }
    await collectionsDAO.insertList(listCollections);
    state = CollectionsState(collections: listCollections, fetchState: kdataFetchState.IS_LOADED);
  }

  changeSelected(SelectorCallback selected) {
    final _selectedFilter = selected.selectedFilter;
    final _selectedSubreddit = selected.selectedSubreddits;
    SharedPreferences.getInstance().then((preferences) {
      preferences.setInt('list_filter', _selectedFilter!);
      preferences.setStringList('list_subreddit', _selectedSubreddit!);
    });
  }
}
