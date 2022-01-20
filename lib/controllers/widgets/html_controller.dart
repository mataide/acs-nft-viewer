import 'dart:convert';

import 'package:faktura_nft_viewer/core/smartcontracts/ERC721.g.dart';
import 'package:faktura_nft_viewer/core/utils/util.dart';
import 'package:flutter/animation.dart';
import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/database_helper/database.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class HtmlState {
  final double contentHeight;
  final bool loaded;

  const HtmlState({this.contentHeight = 0, this.loaded = false});
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
