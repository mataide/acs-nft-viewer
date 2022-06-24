import 'package:faktura_nft_viewer/core/client/APIClient.dart';
import 'package:faktura_nft_viewer/core/models/eth721.dart';
import 'package:faktura_nft_viewer/core/smartcontracts/ERC721.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/database_helper/database.dart';
import "package:collection/collection.dart";
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class HomeCollectionsState {
  final List<Collections?>? collections;
  final kdataFetchState fetchState;
  final int? selectedFilter;
  final RefreshController refreshController;


  HomeCollectionsState(this.refreshController,
      {this.fetchState = kdataFetchState.IS_LOADING,
      this.collections,
      this.selectedFilter,
     });
}

class HomeCollectionsController extends StateNotifier<HomeCollectionsState> {
  HomeCollectionsController([Collections? state])
      : super(HomeCollectionsState(RefreshController(initialRefresh: false)));

  get fetchState => state.fetchState;

  get selectedFilter => state.selectedFilter;

  get collections => state.collections;



  Future<List<Collections>> prepareFromDb() async {
    final database =
    await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsDAO = database.collectionsDAO;
    List<Collections> collections = await collectionsDAO.findAllCollections();
    final preferences = await SharedPreferences.getInstance();
    final listAddress = preferences.getStringList('key');

    //Coleção Vazia
    if (collections.isEmpty) {
      //Lista vazia
      if (listAddress == null || listAddress.isEmpty) {
        return await prepareFromInternet(
            "0x2f8c6f2dae4b1fb3f357c63256fe0543b0bd42fb");
      }
      // lista com carteira
      else {
        for (var i = 0; i < listAddress.length; i++) {
          collections.addAll(await prepareFromInternet(listAddress[i]));
          state = HomeCollectionsState(state.refreshController,
              collections: collections);
        }
        var initial = '0x2f8c6f2dae4b1fb3f357c63256fe0543b0bd42fb';
        var listInitial =
        collections.where((element) => element.to.contains(initial)).toList();
        for (var i = 0; i < listInitial.length; i++) {
          collections.removeAt(i);
        }
        state = HomeCollectionsState(state.refreshController,
            collections: collections);
      }
    }
//Coleção com dados e lista com carteira
    else if (collections.isNotEmpty && listAddress != null){
        //Lista com carteira que não está na coleção
        var collectionTo = [];
        for(var i =0; i < collections.length; i++) {
          collectionTo.add(collections[i].to);
        }
          var differenceSet =
          listAddress.toSet().difference(collectionTo.toSet()).toList();
        print('different linha 79 : $differenceSet');
        if (differenceSet.isNotEmpty) {
          for (var i = 0; i < differenceSet.length; i++) {
            collections.addAll(await prepareFromInternet(differenceSet[i]));
            state = HomeCollectionsState(state.refreshController,
                collections: collections);
          }
          differenceSet = [];
          var initial = '0x2f8c6f2dae4b1fb3f357c63256fe0543b0bd42fb';
          var listInitial = collections
              .where((element) => element.to.contains(initial))
              .toList();
          if(listInitial.isEmpty) {
            for (var i = 0; i < listInitial.length; i++) {
              collections.removeAt(i);
            }
          }
           return collections;
        }
        //coleção com todas as carteiras da lista
        else {

          return collections;
        }

      }
      //coleção com dados mais listAddress igual a nulo
       else {
        return collections;
       }

    state = HomeCollectionsState(state.refreshController,
        collections: collections);

    return collections;
  }


  Future<List<Collections>> prepareFromInternet(String address) async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final eth721Dao = database.eth721DAO;
    final collectionsDAO = database.collectionsDAO;

    final List<Eth721> listERC721 =
        await APIService.instance.getERC721(address);
    var listCollections = <Collections>[];
    var toRemove = <Eth721>[];

    //Web3
    var httpClient = new Client();
    var ethClient = new Web3Client(
        "https://mainnet.infura.io/v3/4b642d6ba815468c8cd8a001bd752738",
        httpClient);

    if (listERC721.isNotEmpty) {
      for (var erc721 in listERC721) {
        final erc = ERC721(
            address: EthereumAddress.fromHex(erc721.contractAddress),
            client: ethClient);
        try {
          //Check if ERC is valid
          await erc.tokenURI(BigInt.parse(erc721.tokenID));
        } catch (error) {
          print(error);
          toRemove.add(erc721);
        }

        if (erc721.from.toLowerCase() == address.toLowerCase()) {
          for (var a in listERC721)
            //Check if ERC was transfer
            if (a.contractAddress.toLowerCase() ==
                    erc721.contractAddress.toLowerCase() &&
                a.tokenID == erc721.tokenID) {
              toRemove.add(a);
              toRemove.add(erc721);
            }
        }
      }
      listERC721.removeWhere((element) => toRemove.contains(element));
      eth721Dao.insertList(listERC721);

      var newMap = groupBy(listERC721, (Eth721 obj) => obj.contractAddress);
      for (var erc721 in newMap.entries) {
        final collections = Collections.fromEth721(
            erc721.value.first, "ethereum", erc721.value.length, false);
        listCollections.add(collections);
      }
      await collectionsDAO.insertList(listCollections);
    }
    state = HomeCollectionsState(state.refreshController,
        collections: listCollections, fetchState: kdataFetchState.IS_LOADED);


    return listCollections;
  }

  void onRefresh() async {
    // monitor network fetch
    final preferences = await SharedPreferences.getInstance();
    final listAddress = preferences.getStringList('key');
    final database =
    await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
    final collectionsDAO = database.collectionsDAO;
    List<Collections> collections = await collectionsDAO.findAllCollections();

    if (listAddress == null)
      await prepareFromInternet("0x2f8c6f2dae4b1fb3f357c63256fe0543b0bd42fb");
    else {
      var collectionTo = [];
      for (var i = 0; i < collections.length; i++) {
        collectionTo.add(collections[i].to);
      }
      var differenceSet =
      listAddress.toSet().difference(collectionTo.toSet()).toList();
      print('different linha 201 : $differenceSet');
      if (differenceSet.isNotEmpty) {
        for (var i = 0; i < differenceSet.length; i++) {
          collections.addAll(await prepareFromInternet(differenceSet[i]));
          state = HomeCollectionsState(state.refreshController,
              collections: collections);
        }

      }
      // if failed,use refreshFailed()
      state.refreshController.refreshCompleted();
      state = HomeCollectionsState(state.refreshController,
          collections: collections, fetchState: kdataFetchState.IS_LOADED);
    }
  }
  void onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    state.refreshController.loadComplete();
  }
}
