
import 'package:faktura_nft_viewer/database_helper/database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLoginState {
  final List<String> listAddress;
  final eventChannel;
  final bool isExpanded;


  const SettingsLoginState({this.listAddress = const [], this.eventChannel = const EventChannel("com.bimsina.re_walls/WalletStreamHandler"), this.isExpanded = false});
}

class SettingsLoginController extends StateNotifier<SettingsLoginState> {
  SettingsLoginController([SettingsLoginState? state]) : super(SettingsLoginState()) {
    sharedRead();

  }
  static SharedPreferences? _sharedPrefs;

  Future<List<String>> sharedWrite(address) async {
    print("address: '$address'.");
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
    state = SettingsLoginState(listAddress: listAddress, isExpanded: state.isExpanded);
    return listAddress;
  }

  Future<List<String>> sharedRead() async {
    final preferences = await SharedPreferences.getInstance();
    final listAddress = preferences.getStringList('key');
    return listAddress ?? [];
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

  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  List<String> get listAddress => _sharedPrefs!.getStringList('key') ?? [];

  set listAddress(List<String> listAddress) {
    _sharedPrefs!.setStringList('key', listAddress);
  }
}

final sharedPrefs = SettingsLoginController();


extension ListExtension<E> on List<E> {
  void addUnique(E element) {
    if (!contains(element)) {
      add(element);
    }
  }
}


