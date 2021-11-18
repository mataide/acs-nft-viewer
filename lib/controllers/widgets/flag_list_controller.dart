import 'dart:convert';

import 'package:faktura_nft_viewer/core/smartcontracts/ERC721.g.dart';
import 'package:faktura_nft_viewer/core/utils/util.dart';
import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/database_helper/database.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FlagListState {
  final List<Collections>? collections;
  final kdataFetchState fetchState;
  final int? selectedFilter;

  const FlagListState({this.fetchState = kdataFetchState.IS_LOADING, this.collections, this.selectedFilter});
}

class FlagListController extends StateNotifier<FlagListState> {
  FlagListController([FlagListState? state]) : super(FlagListState()) {
    prepareFromDb();
  }

  get fetchState => state.fetchState;
  get selectedFilter => state.selectedFilter;
  get collections => state.collections;



  Future<List<Collections>> prepareFromDb() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsDAO = database.collectionsDAO;
    final List<Collections> collections = await collectionsDAO.findAll();
    state = FlagListState(collections: collections);
    return collections;
  }

  Future<String> getCollectionImage(Collections collections) async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsItemDAO = database.collectionsItemDAO;
    final collectionsDAO = database.collectionsDAO;

    //Web3
    var httpClient = new Client();
    var ethClient = new Web3Client("https://mainnet.infura.io/v3/804a4b60b242436f977cacd58ceca531", httpClient);
    final erc = ERC721(address: EthereumAddress.fromHex(collections.contractAddress), client: ethClient);

    var tokenURI = await erc.tokenURI(BigInt.parse(collections.tokenID));
    print(tokenURI);
    tokenURI = ipfsToHTTP(tokenURI);

    final res = await httpClient.get(Uri.parse(tokenURI), headers: {"Accept": "aplication/json"});
    final jsonData = json.decode(res.body);
    var image = ipfsToHTTP((jsonData['image'] as String));

    final head = await httpClient.head(Uri.parse(image), headers: {"Accept": "aplication/json"});
    final contentType = head.headers['content-type'] as String;

    if(contentType.contains('video')) {
      image = (await VideoThumbnail.thumbnailFile(
        video: image,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 400, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      ))!;
    }
    print('image: $image');

    collections.image = image;
    collectionsDAO.update(collections);
    var collectionsItem = CollectionsItem(collections.contractAddress, collections.hash, collections.tokenID, '${jsonData['name']} #${collections.tokenID}', description: jsonData['description'], contentType: contentType, image: image);
    collectionsItemDAO.create(collectionsItem);
    return image;
  }
}
