import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemNftLoginState {
  final List<String> listAddress;
  final eventChannel;
  final bool isVisibility;
  final bool initial;


  const ItemNftLoginState(
      {this.listAddress = const [],
      this.eventChannel =
          const EventChannel("com.bimsina.re_walls/WalletStreamHandler"),
      this.isVisibility = true,
      this.initial = true,
      });
}

class ItemNftController extends StateNotifier<ItemNftLoginState> {
  ItemNftController([ItemNftLoginState? state]) : super(ItemNftLoginState());

  List<String> get listAddress => state.listAddress;

  Future<List<String>> sharedWrite(address) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList('key', address);
    final listAddress = [
      ...{...state.listAddress}
    ];
    return listAddress;
  }

  Future<List<String>> sharedRead() async {
    final preferences = await SharedPreferences.getInstance();
    final listAddress = preferences.getStringList('key');
    state = ItemNftLoginState(listAddress: listAddress ?? []);
    return listAddress ?? [];
  }

  Future sharedRemove(address) async {
    final listAddress = state.listAddress;
    listAddress.remove(address);
    final preferences = await SharedPreferences.getInstance();
    preferences.setStringList('key', listAddress);
    state = ItemNftLoginState(listAddress: listAddress);
  }

  void setWallpaper(file) async {
    const platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
    try {
      final int result = await platform.invokeMethod('setWallpaper', file.path);
      print('Wallpaer Updated.... $result');
    } on PlatformException catch (e) {
      print("Failed to Set Wallpaer: '${e.message}'.");
    }
    // Navigator.pop(context);
  }

  setVisibility() {
    final initial = false;
    state =
        ItemNftLoginState(isVisibility: !state.isVisibility, initial: initial);
  }

  setDelay() {
    if (state.isVisibility == true && state.initial == true) {
      return Future.delayed(Duration(seconds: 4)).then((value) {
        setInitial();
      });
    }
  }

  setReset() {
    final initial = true;
    final isVisibility = true;
    state = ItemNftLoginState(isVisibility: isVisibility, initial: initial);
  }

  setInitial() {
    state = ItemNftLoginState(
        initial: !state.initial, isVisibility: !state.isVisibility);
  }

}
