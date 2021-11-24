
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

  Future<List<String>> sharedWrite(address) async {
    print("address: '$address'.");
    final preferences = await SharedPreferences.getInstance();
    var listAddress = preferences.getStringList('key');
    listAddress != null ? listAddress.addUnique(address) : listAddress = [address];
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
    //state = SettingsLoginState(listAddress: listAddress ?? []);
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
}

extension ListExtension<E> on List<E> {
  void addUnique(E element) {
    if (!contains(element)) {
      add(element);
    }
  }
}