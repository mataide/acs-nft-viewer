
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLoginState {
  final List<String> listAddress;
  final eventChannel;

  const SettingsLoginState({this.listAddress = const [], this.eventChannel = const EventChannel("com.bimsina.re_walls/WalletStreamHandler")});
}

class SettingsLoginController extends StateNotifier<SettingsLoginState> {
  SettingsLoginController([SettingsLoginState? state]) : super(SettingsLoginState()) {
    sharedRead();
  }

  List<String> get listAddress => state.listAddress;

  Future<List<String>> sharedWrite(address) async {
    final preferences = await SharedPreferences.getInstance();
    var listAddress = preferences.getStringList('key');
    listAddress != null ? listAddress.addAllUnique(address) : listAddress = [address];
    await preferences.setStringList('key', listAddress);
    return listAddress;
  }

  Future<List<String>> sharedRead() async {
    final preferences = await SharedPreferences.getInstance();
    final listAddress = preferences.getStringList('key');
    state = SettingsLoginState(listAddress: listAddress ?? []);
    return listAddress ?? [];
  }

  Future sharedRemove(address) async {
    final listAddress = state.listAddress;
    listAddress.remove(address);
    final preferences = await SharedPreferences.getInstance();
    preferences.setStringList('key', listAddress);
    state = SettingsLoginState(listAddress: listAddress);
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
  void addAllUnique(Iterable<E> iterable) {
    for (var element in iterable) {
      if (!contains(element)) {
        add(element);
      }
    }
  }
}