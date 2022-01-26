
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HtmlState {
  final double contentWidth;
  final double contentHeight;
  final bool loaded;

  const HtmlState({this.contentHeight = 1000, this.contentWidth = 0, this.loaded = false});
}

class HtmlController extends StateNotifier<HtmlState> {
  HtmlController() : super(HtmlState());

  void setContentHeight(height) {
    state = HtmlState(contentHeight: height, loaded: state.loaded);
  }

  void setLoaded(loaded) {
    state = HtmlState(contentHeight: state.contentHeight, loaded: loaded);
  }
}
