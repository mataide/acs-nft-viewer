import 'dart:convert';

import 'package:faktura_nft_viewer/core/smartcontracts/ERC721.g.dart';
import 'package:faktura_nft_viewer/core/utils/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/database_helper/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

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
    final erc721DAO = database.eth721DAO;

    List<CollectionsItem> collectionsItemList = await collectionsItemDAO.findCollectionsItemByAddress(state.collections.contractAddress);
    List<Eth721> erc721List = await erc721DAO.findEth721ByAddress(state.collections.contractAddress);

    if(state.collections.totalSupply != collectionsItemList.length) {
      collectionsItemList = [];
      for (var i = 0; i < state.collections.totalSupply!; i++) {
        collectionsItemList.add(await prepareFromInternet(erc721List[i]));
      }
    }
    state = CollectionsItemState(state.collections, collectionsItemList: collectionsItemList);
    return collectionsItemList;
  }

  Future<CollectionsItem> prepareFromInternet(Eth721 eth721) async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsItemDAO = database.collectionsItemDAO;

    //Web3
    var httpClient = new Client();
    var ethClient = new Web3Client("https://mainnet.infura.io/v3/804a4b60b242436f977cacd58ceca531", httpClient);
    final erc = ERC721(address: EthereumAddress.fromHex(eth721.contractAddress), client: ethClient);

    var tokenURI = await erc.tokenURI(BigInt.parse(eth721.tokenID));
    tokenURI = ipfsToHTTP(tokenURI);

    final res = await httpClient.get(Uri.parse(tokenURI), headers: {"Accept": "aplication/json", "Content-ype":"application/json; charset=utf-8"});
    final jsonData = json.decode(utf8.decode(res.bodyBytes));
    var image = ipfsToHTTP((jsonData['image'] as String));
    print(jsonData);
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

    var collectionsItem = CollectionsItem(eth721.contractAddress, eth721.hash, eth721.tokenID, '${jsonData['name']} #${eth721.tokenID}', description: jsonData['description'], contentType: contentType, image: image, video: jsonData['image']);
    collectionsItemDAO.create(collectionsItem);
    return collectionsItem;
  }
}
