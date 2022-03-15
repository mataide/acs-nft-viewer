
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/database_helper/database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLoginState {
  final List<String> listAddress;
  final eventChannel;
  final bool isExpanded;
  final List<Collections?>? collections;
  final int val;
  final XFile? file;

  const SettingsLoginState({this.listAddress = const [], this.eventChannel = const EventChannel("com.bimsina.re_walls/WalletStreamHandler"), this.isExpanded = false, this.collections,this.val = 0, this.file});
}

class SettingsLoginController extends StateNotifier<SettingsLoginState> {
  SettingsLoginController([SettingsLoginState? state]) : super(SettingsLoginState()) {
    //startSettings();
    sharedRead();
  }


/*startSettings() async {
  await _startPreferences();
  await sharedRead();
}
Future<void> _startPreferences() async {
  _prefs = await SharedPreferences.getInstance();

}*/



  Future<List<String>> sharedWrite(address) async {
    final preferences = await SharedPreferences.getInstance();
    var listAddress = preferences.getStringList('key');
    if(listAddress != null && listAddress.isNotEmpty) listAddress.addUnique(address); else {
      final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();
      await database.collectionsDAO.deleteAllCollections();
      await database.collectionsItemDAO.deleteAllCollectionsItem();
      await database.eth721DAO.deleteAll();
      listAddress = [address];
    }
    await preferences.setStringList('key', listAddress);
    state = SettingsLoginState(listAddress: listAddress, isExpanded: state.isExpanded);
    return listAddress;
  }

  Future<List<String>> sharedRemove(address) async {
    final preferences = await SharedPreferences.getInstance();
    var listAddress = preferences.getStringList('key');
    listAddress!.remove(address);
    await preferences.setStringList('key', listAddress);

    final database = await $FloorFlutterDatabase.databaseBuilder(
        'app_database.db').build();
    await database.eth721DAO.deleteEth721ByAddress(address);
    await database.collectionsDAO.deleteCollectionsByAddress(address);

    state = SettingsLoginState(listAddress: listAddress, isExpanded: state.isExpanded);
    return listAddress;
  }

  Future<List<String>> sharedRead() async {
    final preferences = await SharedPreferences.getInstance();
    final listAddress = preferences.getStringList('key');
    state = SettingsLoginState(listAddress: listAddress!, isExpanded: state.isExpanded);
    return listAddress;
  }

  setExpanded() {
     state = SettingsLoginState(listAddress: state.listAddress, isExpanded: !state.isExpanded);
  }


  openMetaMask() async {
    const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
    try {
      await platform.invokeMethod('initWalletConnection', null);
    } on PlatformException catch (e) {
      print("Failed to initWalletConnection: '${e.message}'.");
    }
  }
  deleteAll() async {
      final database = await $FloorFlutterDatabase.databaseBuilder(
          'app_database.db').build();
      await database.collectionsDAO.deleteAllCollections();
      await database.collectionsItemDAO.deleteAllCollectionsItem();
      await database.eth721DAO.deleteAll();
    }
    setFeedBack(int val){
    state = SettingsLoginState(
      val: val
    );
    return val;
    }
  setFile(XFile? file){
    state = SettingsLoginState(
        file: file
    );
    return file;
  }

}
extension ListExtension<E> on List<E> {
  void addUnique(E element) {
    if (!contains(element)) {
      add(element);
    }
  }
  }



