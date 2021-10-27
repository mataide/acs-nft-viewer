import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/core/models/index.dart';

class HomeState {
  final int selectedIndex;

  const HomeState({this.selectedIndex = 0});
}

class HomeController extends StateNotifier<HomeState> {
  HomeController([HomeState? state]) : super(HomeState());

  int get selectedIndex => state.selectedIndex;

  void setIndex(index) {
    state = HomeState(selectedIndex: index);
  }
}
