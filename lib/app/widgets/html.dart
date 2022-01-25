import 'dart:io';
import 'dart:math';

import 'package:faktura_nft_viewer/controllers/widgets/html_controller.dart';
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
    late WebViewController _controller;
    final controller =
    ref.read(htmlProvider.notifier);
    final HtmlState dataState = ref.watch(htmlProvider);
    final ThemeData state = ref.watch(themeProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    var url = collectionsItemList[index].animationUrl!;

    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    return Container(
      width: double.infinity,
      height: dataState.contentHeight,
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: url,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
            onProgress: (int progress) {
              print('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) async {
              print('[webView/onPageFinished] finished loading "$url"');
              controller.setLoaded(true);
              if (_controller != null) {
                controller.setContentHeight(double.tryParse(
                  await _controller
                      .runJavascriptReturningResult("document.body.offsetHeight;"),
                ));
                var width = await _controller
                    .runJavascriptReturningResult("document.body.offsetWidth;");
                print('Page width: $width');
              }
            },
          ),
          if (!dataState.loaded)
            CircularProgressIndicator(color: state.primaryColor)
        ],
      ));
  }
}
