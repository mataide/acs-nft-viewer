import 'dart:convert';

import 'package:faktura_nft_viewer/core/smartcontracts/ERC721.g.dart';
import 'package:faktura_nft_viewer/core/utils/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/database_helper/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class CollectionsItemState {
  final Collections collections;
  final kdataFetchState fetchState;
  final List<CollectionsItem> collectionsItemList;

  CollectionsItemState(
    this.collections, {
    this.fetchState = kdataFetchState.IS_LOADING,
    this.collectionsItemList = const [],
  });
}

class CollectionsItemController extends StateNotifier<CollectionsItemState> {
  CollectionsItemController(Collections collections)
      : super(CollectionsItemState(collections));

  Future<List<CollectionsItem>> prepareFromDb() async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsItemDAO = database.collectionsItemDAO;
    final erc721DAO = database.eth721DAO;

    List<CollectionsItem> collectionsItemList = await collectionsItemDAO
        .findCollectionsItemByAddress(state.collections.contractAddress);
    List<Eth721> erc721List = await erc721DAO
        .findEth721ByContractAddress(state.collections.contractAddress);


    if(erc721List.length == collectionsItemList.length){
      state = CollectionsItemState(state.collections,
          collectionsItemList: collectionsItemList);
      return collectionsItemList;
    }else{

      var erc721Hash = [];
      List<Eth721> list721Hash = [];
      for (var i = 0; i < erc721List.length; i++) {
        erc721Hash.add(erc721List[i].hash);
        list721Hash.add(erc721List[i]);
      }
      var itemHash = [];
      for (var i = 0; i < collectionsItemList.length; i++) {
        itemHash.add(collectionsItemList[i].hash);
      }

      //o que esta na tabela erc721 e não está na collectionItem
      var differenceSet =
          erc721Hash.toSet().difference(itemHash.toSet()).toList();
      if (differenceSet.isNotEmpty) {
        for (var i = 0; i < erc721Hash.length; i++) {
        for(var a = 0; a < differenceSet.length; a++) {
          var test = differenceSet[a].toString();
          if (erc721Hash[i] == test) {
            collectionsItemList.add(
                await prepareFromInternet(list721Hash[i]));
            state = CollectionsItemState(state.collections,
                collectionsItemList: collectionsItemList);
          }
        }

        }
      } else
        return collectionsItemList;
    }
    state = CollectionsItemState(state.collections,
        collectionsItemList: collectionsItemList);
    return collectionsItemList;
  }

  Future<CollectionsItem> prepareFromInternet(Eth721 eth721) async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsItemDAO = database.collectionsItemDAO;

    //Web3
    var httpClient = new Client();
    var ethClient = new Web3Client(
        "https://mainnet.infura.io/v3/4b642d6ba815468c8cd8a001bd752738",
        httpClient);
    final erc = ERC721(
        address: EthereumAddress.fromHex(eth721.contractAddress),
        client: ethClient);

    var tokenURI = await erc.tokenURI(BigInt.parse(eth721.tokenID));
    tokenURI = ipfsToHTTP(tokenURI);
    final res = await httpClient.get(Uri.parse(tokenURI), headers: {
      "Accept": "aplication/json",
      "Content-ype": "application/json; charset=utf-8"
    });
    final jsonData = json.decode(utf8.decode(res.bodyBytes));
    var image = ipfsToHTTP((jsonData['image'] as String));
    final head = await httpClient
        .head(Uri.parse(image), headers: {"Accept": "aplication/json"});
    var contentType = head.headers['content-type'] as String;

    if (jsonData['name'] == null) {
      jsonData['name'] = await erc.name();
    }
    if (image.length > 120) {
      image = "";
    }
    if (contentType.contains('video')) {
      jsonData['animation_url'] = image;
      image = (await VideoThumbnail.thumbnailFile(
        video: image,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 400,
        // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      ))!;
    }

    if (jsonData['animation_url'] != null) {
      var animation_url = ipfsToHTTP((jsonData['animation_url'] as String));
      final head = await httpClient.head(Uri.parse(animation_url),
          headers: {"Accept": "aplication/json"});
      contentType = head.headers['content-type'] as String;
    }

    var attributes;
    if (jsonData['attributes'] != null) {
      var list = jsonData['attributes'] as List;
      List<Attributes> dataList =
          list.map((i) => Attributes.fromJson(i)).toList();
      attributes = dataList;
    } else {
      attributes = <Attributes>[];
    }

    var collectionsItem = CollectionsItem(
        eth721.contractAddress,
        eth721.hash,
        eth721.tokenID,
        '${jsonData['name']} #${eth721.tokenID}',
        image,
        attributes,
        description: jsonData['description'],
        contentType: contentType,
        animationUrl: jsonData['animation_url']);
    collectionsItemDAO.create(collectionsItem);
    return collectionsItem;
  }
}
