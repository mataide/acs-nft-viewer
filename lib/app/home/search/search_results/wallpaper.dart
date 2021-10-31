import 'package:NFT_View/app/widgets/dialog.dart';
import 'package:NFT_View/controllers/home/search/wallpaper_controller.dart';
import 'package:NFT_View/core/models/response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../collections/collections_widget.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../search_web.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

class WallpaperView extends ConsumerWidget implements TickerProvider {

  final List<Post?> _posts;
  final int _index;
  final String _heroId;

  WallpaperView(
      this._heroId, this._posts, this._index);

  Ticker? _ticker;
  late AnimationController _controller;
  BoxFit fit = BoxFit.cover;
  final platform = const MethodChannel('com.bimsina.re_walls/MainActivity');
  PageController? _pageController;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider);
    final dataState = watch(wallpaperProvider.notifier);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read(wallpaperProvider.notifier).setInitialData(_posts, _index, _heroId, _posts[_index]);
    });

    _pageController = PageController(initialPage: dataState.index);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    return Scaffold(
      body: _buildUI(state, context, watch, dataState),
    );
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null)
        return true;
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$runtimeType is a SingleTickerProviderStateMixin but multiple tickers were created.'),
        ErrorDescription('A SingleTickerProviderStateMixin can only be used as a TickerProvider once.'),
        ErrorHint(
          'If a State is used for multiple AnimationController objects, or if it is passed to other '
              'objects and those objects might use it more than one time in total, then instead of '
              'mixing in a SingleTickerProviderStateMixin, use a regular TickerProviderStateMixin.',
        ),
      ]);
    }());
    _ticker = Ticker(onTick, debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null);
    // We assume that this is called from initState, build, or some sort of
    // event handler, and that thus TickerMode.of(context) would return true. We
    // can't actually check that here because if we're in initState then we're
    // not allowed to do inheritance checks yet.
    return _ticker!;
  }

  Widget _buildUI(ThemeData themeData, context, watch,WallPaperController dataState) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (_controller.isCompleted) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
            },
            child: Hero(
              tag: dataState.heroId,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: themeData.primaryColor,
                child: PageView(
                  controller: _pageController,
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    dataState.setCurrentPost(index);
                  },
                  children: dataState.posts
                      .map(
                        (item) => CachedNetworkImage(
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                            child: Icon(
                              Icons.error,
                              color: themeData.accentColor,
                            )),
                      ),
                      fit: fit,
                      placeholder: (context, url) => Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.network(
                            item!.preview!.images![0].resolutions![0].url!,
                            fit: fit,
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  themeData.colorScheme.secondary),
                            ),
                          ),
                        ],
                      ),
                      imageUrl: item!.url!,
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Transform.translate(
                  offset: Offset(0, -_controller.value * 80),
                  child: Container(
                    height: 80.0,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 24),
                    decoration: BoxDecoration(
                      color: themeData.primaryColorDark.withOpacity(0.9),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: themeData.textTheme.bodyText2!.color,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            fit == BoxFit.contain
                                ? Icons.fullscreen
                                : Icons.fullscreen_exit,
                            color: themeData.textTheme.bodyText2!.color,
                          ),
                          onPressed: () {
                            if (fit == BoxFit.contain) {
                              fit = BoxFit.cover;
                            } else {
                              fit = BoxFit.contain;
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, _controller.value * 150),
                  child: bottomSheet(themeData, context, watch, dataState),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void downloadImage(ThemeData themeData, context, watch,WallPaperController dataState) async {
    try {
      PermissionStatus status = await Permission.storage.status;

      if (status == PermissionStatus.granted) {
        try {
          showToast('Check the notification to see progress.');

          var imageId = await ImageDownloader.downloadImage(dataState.currentPost!.url!,
              destination: AndroidDestinationType.directoryDownloads);
          if (imageId == null) {
            return;
          }
        } on PlatformException catch (error) {
          print(error);
        }
      } else {
        askForPermission(themeData, context, watch, dataState);
      }
    } catch (e) {
      print(e);
    }
  }

  void askForPermission(ThemeData themeData, context, watch,WallPaperController dataState) async {
    if (await Permission.storage.request().isGranted) {
      downloadImage(themeData, context, watch, dataState);
    } else {
      showToast('Please grant storage permission.');
    }
  }

  void _setWallpaper(ThemeData themeData, context, watch,WallPaperController dataState) async {
    var file = await DefaultCacheManager().getSingleFile(dataState.currentPost!.url!);
    try {
      final int? result = await platform.invokeMethod('setWallpaper', file.path);
      print('Wallpaer Updated.... $result');
    } on PlatformException catch (e) {
      print("Failed to Set Wallpaer: '${e.message}'.");
    }
    Navigator.pop(context);
  }

  void showToast(String content) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);

  Widget bottomSheet(ThemeData themeData, context, watch,WallPaperController dataState) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        color: themeData.primaryColorDark.withOpacity(0.9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            dataState.currentPost!.title!,
            style: themeData.textTheme.bodyText2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Posted on r/${dataState.currentPost!.subreddit} by u/${dataState.currentPost!.author}',
            style: themeData.textTheme.bodyText1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: <Widget>[
              ColButton(
                title: 'Set Wallpaper',
                icon: Icons.wallpaper,
                onTap: () async {
                  showLoadingDialog(context, watch);
                  await Future.delayed(Duration(seconds: 1));
                  _setWallpaper(themeData, context, watch, dataState);
                },
              ),
              ColButton(
                title: 'Download',
                icon: Icons.file_download,
                onTap: () {
                  downloadImage(themeData, context, watch, dataState);
                },
              ),
              ColButton(
                title: 'Share',
                icon: Icons.share,
                onTap: () {
                  Share.share(
                      'Checkout this awesome wallpaper I found on reWalls ${dataState.currentPost!.url}');
                },
              ),
              ColButton(
                title: 'Source',
                icon: Icons.open_in_browser,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchWeb(
                                title: dataState.currentPost!.title,
                                initialPage: 'https://www.reddit.com' +
                                    dataState.currentPost!.permalink!,
                              )));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}
