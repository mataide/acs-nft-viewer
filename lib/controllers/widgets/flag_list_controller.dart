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
  FlagListController([FlagListState? state]) : super(FlagListState());

  get fetchState => state.fetchState;
  get selectedFilter => state.selectedFilter;
  get collections => state.collections;

  Future<String> prepareFromDb(Collections collections) async {
    return collections.image ?? await prepareFromInternet(collections);
  }

  Future<String> prepareFromInternet(Collections collections) async {
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

    final res = await httpClient.get(Uri.parse(tokenURI), headers: {"Accept": "aplication/json", "Content-ype":"application/json; charset=utf-8"});
    final jsonData = json.decode(utf8.decode(res.bodyBytes));
    var image = ipfsToHTTP((jsonData['image'] as String));


    final head = await httpClient.head(Uri.parse(image), headers: {"Accept": "aplication/json"});
    var contentType = head.headers['content-type'] as String;

    if(contentType.contains('video')) {
      image = (await VideoThumbnail.thumbnailFile(
        video: image,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 400, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      ))!;
    }

    if(jsonData['animation_url'] != null) {
      var animation_url = ipfsToHTTP((jsonData['animation_url'] as String));

      final head = await httpClient.head(Uri.parse(animation_url), headers: {"Accept": "aplication/json"});
      contentType = head.headers['content-type'] as String;
    }

    collections.image = image;
    collections.description = jsonData['description'];
    collections.externalUrl = jsonData['external_url'];
    collectionsDAO.update(collections);

    var attributes;
    if(jsonData['traits'] != null) {
      var list = jsonData['traits'] as List;
      List<Attributes> dataList = list.map((i) => Attributes.fromJson(i)).toList();
      attributes = dataList;
    } else {
      attributes = <Attributes>[];
    }

    var collectionsItem = CollectionsItem(collections.contractAddress, collections.hash, collections.tokenID, '${jsonData['name']} #${collections.tokenID}', image, attributes, description: jsonData['description'], contentType: contentType, animationUrl: jsonData['animation_url']);
    collectionsItemDAO.create(collectionsItem);
    return image;
  }
}
