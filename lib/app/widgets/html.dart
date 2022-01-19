import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlWidget extends ConsumerWidget {
  final List<CollectionsItem> collectionsItemList;
  final int index;

  HtmlWidget(this.collectionsItemList, this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WebViewController _controller;
    final ThemeData state = ref.watch(themeProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    var url = collectionsItemList[index].animationUrl!;

    return Container(
      width: 393,
      height: 814,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: WebView(
        initialUrl: url,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
      ),
    );
  }
}
