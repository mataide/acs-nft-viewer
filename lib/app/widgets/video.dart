import 'dart:async';

import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:faktura_nft_viewer/core/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends ConsumerWidget {
  final List<CollectionsItem> collectionsItemList;
  final int index;


  VideoWidget(this.collectionsItemList, this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData state = ref.watch(themeProvider);
    String animationUrl = collectionsItemList[index].animationUrl!.toString();
    String url = animationUrl.replaceAll("ipfs://", "https://ipfs.io/ipfs/");
    VideoPlayerController controller;
    Future<void> _initializeVideoPlayerFuture;
   controller = VideoPlayerController.network(
    url,
    );

    _initializeVideoPlayerFuture = controller.initialize();
    controller.setLooping(true);
    return Align(
        alignment: Alignment.center,
    child: Container(
        alignment: Alignment.center,
        child:
        Column(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  controller.play();
                  return AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: Align(alignment: Alignment.center,child: Stack(
                        children: [
                          VideoPlayer(controller,),
                        ],
                      )));
                } else {
                  return Center(
                      child: CircularProgressIndicator(color: state.hoverColor));
                }
              },
            ),
          ],
        ))
    );
  }


}
