import 'dart:convert';

import 'package:http/http.dart';
import 'package:NFT_View/core/client/APIClient.dart';
import 'package:NFT_View/app/widgets/selector.dart';
import 'package:NFT_View/core/models/eth721.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:NFT_View/core/utils/constants.dart';
import 'package:NFT_View/core/models/response.dart';
import 'package:NFT_View/database_helper/database.dart';
import 'package:NFT_View/core/smartcontracts/ERC721.g.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Collections {
  final List<Post?>? posts;
  final kdataFetchState fetchState;
  final int? selectedFilter;
  final List<String>? subreddits, selectedSubreddit;

  const Collections({this.fetchState = kdataFetchState.IS_LOADING, this.posts, this.selectedFilter, this.subreddits, this.selectedSubreddit});
}

class CollectionsController extends StateNotifier<Collections> {
  CollectionsController([Collections? state]) : super(Collections()) {
    prepareSharedPrefs();
    prepareFromDb();
  }

  get fetchState => Collections().fetchState;
  get selectedSubreddit => Collections().selectedSubreddit;
  get selectedFilter => Collections().selectedFilter;
  get subreddits => Collections().subreddits;
  get posts => Collections().posts;

  prepareSharedPrefs() async {
    SharedPreferences.getInstance().then((preferences) {
      final _subreddits = preferences.getStringList('subredditsList') ?? initialSubredditsList;
      final _selectedFilter = preferences.getInt('list_filter') ?? 0;
      final _selectedSubreddit = preferences.getStringList('list_subreddit') ??
          [_subreddits[4], _subreddits[5]];
      state = Collections(subreddits: _subreddits, selectedFilter: _selectedFilter, selectedSubreddit: _selectedSubreddit);
      prepareFromInternet();
    });
  }

  fetchWallPapers(String subreddit) async {
    // fetchState = kdataFetchState.IS_LOADING;
    // notifyListeners();
    // try {
    //   http.get(Uri.parse(subreddit)).then((res) {
    //     if (res.statusCode == 200) {
    //       var decodeRes = jsonDecode(res.body);
    //       _posts = [];
    //       Reddit temp = Reddit.fromJson(decodeRes);
    //       temp.data!.children!.forEach((children) {
    //         if (children.post!.postHint == 'image') {
    //           _posts!.add(children.post);
    //         }
    //       });
    //
    //       _fetchState = kdataFetchState.IS_LOADED;
    //       notifyListeners();
    //     } else {
    //       _fetchState = kdataFetchState.ERROR_ENCOUNTERED;
    //       notifyListeners();
    //     }
    //   });
    // } catch (e) {
    //   _fetchState = kdataFetchState.ERROR_ENCOUNTERED;
    //   notifyListeners();
    // }
  }

  void prepareFromDb() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();

    final eth721Dao = database.eth721DAO;
    final result = await eth721Dao.findAll();
    print(result);
  }

  void prepareFromInternet() async {
    final List<Eth721> listERC721 = await APIService.instance.getERC721("0x2f8c6f2dae4b1fb3f357c63256fe0543b0bd42fb");
    print(listERC721.toList());
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final eth721Dao = database.eth721DAO;
    eth721Dao.insertListEth721(listERC721);
    //Web3
    var httpClient = new Client();
    var ethClient = new Web3Client("https://mainnet.infura.io/v3/804a4b60b242436f977cacd58ceca531", httpClient);
    final erc = ERC721(address: EthereumAddress.fromHex(listERC721.first.contractAddress), client: ethClient);
    final tokenURI = await erc.tokenURI(BigInt.parse(listERC721.first.tokenID));
    print(tokenURI);
    if(tokenURI.startsWith("http")) {
      final res = await httpClient.get(Uri.parse(tokenURI), headers: {"Accept": "aplication/json"});
      final jsonData = json.decode(res.body);
      print(jsonData);
      if((jsonData['image'] as String).contains('mp4')) {
        final fileName = await VideoThumbnail.thumbnailFile(
          video: jsonData['image'],
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.PNG,
          maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
          quality: 75,
        );
        print(fileName);
      }

    }


    // String jsonData = await rootBundle.loadString('assets/json/ERC721.abi.json');
    // DeployedContract contract = DeployedContract(ContractAbi.fromJson(jsonData, "ERC721"), EthereumAddress.fromHex(listERC721.first.contractAddress));
    // ethClient.call(contract: contract, function: contract.function("tokenURI"), params: );
    final _fetchState = kdataFetchState.IS_LOADED;
    state = Collections(fetchState: _fetchState);
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
