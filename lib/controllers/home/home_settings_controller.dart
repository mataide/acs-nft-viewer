import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/core/models/index.dart';

class HomeSettingsState {
  final bool wantKeepAlive;
  final String cacheSize;

  const HomeSettingsState({this.wantKeepAlive = true, this.cacheSize = 'N/A'});
}

class HomeSettingsController extends StateNotifier<HomeSettingsState> {
  HomeSettingsController([HomeSettingsState? state]) : super(HomeSettingsState());

  bool get wantKeepAlive => state.wantKeepAlive;
  String get cacheSize => state.cacheSize;
}
