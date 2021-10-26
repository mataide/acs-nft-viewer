import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/core/models/index.dart';

class HomeState {
  final int selectedIndex;

  const HomeState({this.selectedIndex = 0});
}

class HomeController extends StateNotifier<HomeState> {
  HomeController([Collections? state]) : super(HomeState()) {}

  get selectedIndex => HomeState().selectedIndex;

  void setIndex(index) async {
    state = HomeState(selectedIndex: index);
  }
}
