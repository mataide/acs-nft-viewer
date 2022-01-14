import 'dart:async';

import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlWidget extends ConsumerWidget {
  final List<CollectionsItem> collectionsItemList;
  final int index;


  HtmlWidget(this.collectionsItemList, this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData state = ref.watch(themeProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    var url = collectionsItemList[index].animationUrl!;

    return
        WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: url
    );
  }

}
