import 'dart:convert';

import 'package:NFT_View/core/smartcontracts/CurseNFT.g.dart';
import 'package:NFT_View/core/utils/util.dart';
import 'package:http/http.dart';
import 'package:NFT_View/core/client/APIClient.dart';
import 'package:NFT_View/app/widgets/selector.dart';
import 'package:NFT_View/core/models/eth721.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:NFT_View/core/utils/constants.dart';
import 'package:NFT_View/core/models/index.dart';
import 'package:NFT_View/database_helper/database.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import "package:collection/collection.dart";

class CollectionsState {
  final List<Collections?>? collections;
  final List<CollectionsItem>? collectionsItem;
  final kdataFetchState fetchState;
  final int? selectedFilter;
  final List<String>? subreddits, selectedSubreddit;

  const CollectionsState({this.fetchState = kdataFetchState.IS_LOADING, this.collections, this.collectionsItem, this.selectedFilter, this.subreddits, this.selectedSubreddit});
}

class HomeCollectionsController extends StateNotifier<CollectionsState> {
  HomeCollectionsController([Collections? state]) : super(CollectionsState()) {
    prepareFromInternet();
  }

  get fetchState => state.fetchState;
  get selectedSubreddit => state.selectedSubreddit;
  get selectedFilter => state.selectedFilter;
  get subreddits => state.subreddits;
  get collections => state.collections;

  prepareSharedPrefs() async {
    SharedPreferences.getInstance().then((preferences) {
      final _subreddits = preferences.getStringList('subredditsList') ?? initialSubredditsList;
      final _selectedFilter = preferences.getInt('list_filter') ?? 0;
      final _selectedSubreddit = preferences.getStringList('list_subreddit') ??
          [_subreddits[4], _subreddits[5]];
      state = CollectionsState(subreddits: _subreddits, selectedFilter: _selectedFilter, selectedSubreddit: _selectedSubreddit);
      prepareFromInternet();
    });
  }

  fetchWallPapers(String subreddit) async {
  }

  Future<List<Collections>> prepareFromDb() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsDAO = database.collectionsDAO;
    return await collectionsDAO.findAll();
  }

  void prepareFromInternet() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final eth721Dao = database.eth721DAO;
    final collectionsItemDAO = database.collectionsItemDAO;

    final List<Eth721> listERC721 = await APIService.instance.getERC721("0x2f8c6f2dae4b1fb3f357c63256fe0543b0bd42fb");
    print(listERC721.toList());
    eth721Dao.insertList(listERC721);
    var newMap = groupBy(listERC721, (Eth721 obj) => obj.contractAddress);
    late List<Collections> listCollections = [];
    late List<CollectionsItem> listCollectionsItem = [];
    for (var erc721 in newMap.entries) {
    final collections = Collections.fromEth721(erc721.value.first, erc721.value.length);
    final collectionsItem = CollectionsItem(erc721.value.first.contractAddress, erc721.value.first.hash, erc721.value.first.tokenID, erc721.value.first.tokenName);
      listCollectionsItem.add(collectionsItem);
      listCollections.add(collections);
    }
    await collectionsItemDAO.insertList(listCollectionsItem);


    state = CollectionsState(collections: listCollections, collectionsItem: listCollectionsItem, fetchState: kdataFetchState.IS_LOADED);
  }

  Future<CollectionsItem> getCollectionItem(Collections collections) async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsItemDAO = database.collectionsItemDAO;
    //Web3
    var httpClient = new Client();
    var ethClient = new Web3Client("https://mainnet.infura.io/v3/804a4b60b242436f977cacd58ceca531", httpClient);
    final erc = CurseNFT(address: EthereumAddress.fromHex(collections.contractAddress), client: ethClient);

    var tokenURI = await erc.tokenURI(BigInt.parse(collections.tokenID));
    print(tokenURI);
    tokenURI = ipfsToHTTP(tokenURI);

    final res = await httpClient.get(Uri.parse(tokenURI), headers: {"Accept": "aplication/json"});
    final jsonData = json.decode(res.body);
    var image = ipfsToHTTP((jsonData['image'] as String));

    final head = await httpClient.head(Uri.parse(image), headers: {"Accept": "aplication/json"});
    final contentType = head.headers['content-type'] as String;

    var thumbnail;
    if(contentType.contains('video')) {
      thumbnail = await VideoThumbnail.thumbnailFile(
        video: image,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
    }

    var collectionsItem = CollectionsItem(collections.contractAddress, collections.hash, collections.tokenID, '${jsonData['name']} #${collections.tokenID}', description: jsonData['description'], contentType: contentType, thumbnail: thumbnail, image: image);
    collectionsItemDAO.create(collectionsItem);
    return collectionsItem;
  }

  changeSelected(SelectorCallback selected) {
    final _selectedFilter = selected.selectedFilter;
    final _selectedSubreddit = selected.selectedSubreddits;
    SharedPreferences.getInstance().then((preferences) {
      preferences.setInt('list_filter', _selectedFilter!);
      preferences.setStringList('list_subreddit', _selectedSubreddit!);
      prepareSharedPrefs();
    });
  }
}
