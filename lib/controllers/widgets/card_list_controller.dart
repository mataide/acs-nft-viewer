import 'dart:convert';

import 'package:faktura_nft_viewer/core/smartcontracts/ERC721.g.dart';
import 'package:faktura_nft_viewer/core/utils/util.dart';
import 'package:flutter/animation.dart';
import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/database_helper/database.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CardListState {
  final List<CollectionsItem> collectionsItemList;
  final kdataFetchState fetchState;
  final Function? onCityChange;
  final double prevScrollX;
  final bool isScrolling;
  final double normalizedOffset;
  final AnimationController? tweenController;
  final Tween<double>? tween;
  final Animation<double>? tweenAnim;

  const CardListState(this.collectionsItemList, {this.tweenController, this.tween, this.tweenAnim, this.fetchState = kdataFetchState.IS_LOADING, this.onCityChange, this.prevScrollX = 0, this.isScrolling = false, this.normalizedOffset = 0});
}

class CardListController extends StateNotifier<CardListState> {
  CardListController(List<CollectionsItem> collectionsItemList) : super(CardListState(collectionsItemList));

  Future<List<CollectionsItem>> prepareFromDb() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsItemDAO = database.collectionsItemDAO;
    final List<CollectionsItem> collectionsItem = await collectionsItemDAO.findAllCollectionsItem();
    state = CardListState(collectionsItem);
    return collectionsItem;
  }

  setTweenController(tweenController) {
    state = CardListState(state.collectionsItemList, onCityChange: state.onCityChange, prevScrollX: state.prevScrollX, isScrolling: state.isScrolling, normalizedOffset: state.normalizedOffset, fetchState: state.fetchState, tween: state.tween, tweenAnim: state.tweenAnim, tweenController: tweenController);
  }

  setIsScrolling(isScrolling) {
    state = CardListState(state.collectionsItemList, onCityChange: state.onCityChange, prevScrollX: state.prevScrollX, isScrolling: isScrolling, normalizedOffset: state.normalizedOffset, fetchState: state.fetchState, tween: state.tween, tweenAnim: state.tweenAnim, tweenController: state.tweenController);
    print(state.isScrolling);
  }

  setPrevScrollX(prevScrollX) {
    state = CardListState(state.collectionsItemList, onCityChange: state.onCityChange, prevScrollX: prevScrollX, isScrolling: state.isScrolling, normalizedOffset: state.normalizedOffset, fetchState: state.fetchState, tween: state.tween, tweenAnim: state.tweenAnim, tweenController: state.tweenController);
  }

  Future<CollectionsItem> getCollectionItem(CollectionsItem collections) async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsItemDAO = database.collectionsItemDAO;
    //Web3
    var httpClient = new Client();
    var ethClient = new Web3Client("https://mainnet.infura.io/v3/804a4b60b242436f977cacd58ceca531", httpClient);
    final erc = ERC721(address: EthereumAddress.fromHex(collections.contractAddress), client: ethClient);

    var tokenURI = await erc.tokenURI(BigInt.parse(collections.id));
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

    var collectionsItem = CollectionsItem(collections.contractAddress, collections.hash, collections.id, '${jsonData['name']} #${collections.id}', description: jsonData['description'], contentType: contentType, image: image);
    collectionsItemDAO.create(collectionsItem);
    return collectionsItem;
  }
}
