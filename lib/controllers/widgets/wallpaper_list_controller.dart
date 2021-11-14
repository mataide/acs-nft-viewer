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

class WallpaperListState {
  final List<Collections?>? collections;
  final kdataFetchState fetchState;
  final int? selectedFilter;
  final List<String>? subreddits, selectedSubreddit;

  const WallpaperListState({this.fetchState = kdataFetchState.IS_LOADING, this.collections, this.selectedFilter, this.subreddits, this.selectedSubreddit});
}

class WallpaperListController extends StateNotifier<WallpaperListState> {
  WallpaperListController([WallpaperListState? state]) : super(WallpaperListState()) {
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
      state = WallpaperListState(subreddits: _subreddits, selectedFilter: _selectedFilter, selectedSubreddit: _selectedSubreddit);
      prepareFromInternet();
    });
  }

  Future<List<Collections>> prepareFromDb() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsDAO = database.collectionsDAO;
    return await collectionsDAO.findAll();
  }

  Future<CollectionsItem> getCollectionItem(CollectionsItem collections) async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsItemDAO = database.collectionsItemDAO;
    //Web3
    var httpClient = new Client();
    var ethClient = new Web3Client("https://mainnet.infura.io/v3/804a4b60b242436f977cacd58ceca531", httpClient);
    final erc = CurseNFT(address: EthereumAddress.fromHex(collections.contractAddress), client: ethClient);

    var tokenURI = await erc.tokenURI(BigInt.parse(collections.id));
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

    var collectionsItem = CollectionsItem(collections.contractAddress, collections.hash, collections.id, '${jsonData['name']} #${collections.id}', description: jsonData['description'], contentType: contentType, thumbnail: thumbnail, image: image);
    collectionsItemDAO.create(collectionsItem);
    return collectionsItem;
  }
}
