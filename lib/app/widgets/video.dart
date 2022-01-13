import 'dart:async';

import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
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
    final VideoPlayerController controller;
    Future<void> _initializeVideoPlayerFuture;
    controller = VideoPlayerController.network(
      collectionsItemList[index].animationUrl!,
    );

    _initializeVideoPlayerFuture = controller.initialize();
    controller.setLooping(true);
    return Expanded(
        child: Container(
            child: Column(
      children: [
        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              );
            } else {
              return Center(child: CircularProgressIndicator(color: state.accentColor));
            }
          },
        ),
        FloatingActionButton(
          onPressed: () {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          },
          child: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ],
    )));
  }
}
