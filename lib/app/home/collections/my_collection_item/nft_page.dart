import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:faktura_nft_viewer/app/home/collections/my_collection_item/nft_screen.dart';
import 'package:faktura_nft_viewer/app/routes/white_page_route.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:faktura_nft_viewer/core/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class NftPageView extends ConsumerWidget {
  final List<CollectionsItem> collectionsItemList;
  final int index;

  static const platform =
      const MethodChannel('com.bimsina.re_walls/MainActivity');

  NftPageView(this.collectionsItemList, this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.read(wallpaperListProvider(collectionsItemList).notifier);
    final state = ref.watch(themeProvider);
    final dataStat = ref.watch(itemNftProvider.notifier);
    final dataState = ref.watch(homeCollectionsProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    var type = collectionsItemList[index].contentType;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: state.primaryColor,
        actionsIconTheme: IconThemeData(color: state.cardColor),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/wallpaper.svg',
              semanticsLabel: 'Wallpaper icon',
              color: state.textTheme.caption!.color,
            ),
            onPressed: () async {
              showLoadingDialog(context, state);
              await Future.delayed(Duration(milliseconds: 1000));
              _setWallpaper(context);
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/download.svg',
              semanticsLabel: 'Download icon',
              color: state.textTheme.caption!.color,
            ),
            onPressed: () {
              downloadImage();
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/share.svg',
              semanticsLabel: 'Share icon',
              color: state.textTheme.caption!.color,
            ),
            onPressed: () {
              if (type!.contains("video")) {
                Share.share(
                    'Checkout this amazing NFT mine. ${collectionsItemList[index].animationUrl!}');
              } else {
                Share.share(
                    'Checkout this amazing NFT mine. ${collectionsItemList[index].image}');
              }
            },
          ),
        ],
        iconTheme: state.primaryIconTheme,
        elevation: 0.0,
      ),
      backgroundColor: state.primaryColor,
      body: SingleChildScrollView(
          child: Column(children: [
        FutureBuilder<CollectionsItem>(
            future: controller.getCollectionItem(collectionsItemList[index]),
            // function where you call your api
            builder: (BuildContext context,
                AsyncSnapshot<CollectionsItem> snapshot) {
              // AsyncSnapshot<Your object type>
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Text(
                  'Please wait its loading...',
                  style: TextStyle(color: state.textTheme.bodyText1!.color),
                ));
              } else {
                if (snapshot.hasError)
                  return Center(
                      child: Text('getCollectionImage: ${snapshot.error}'));
                else
                  return SingleChildScrollView(
                    child: Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: (width * 0.02), right: (width * 0.02)),
                        child: Column(children: [
                          SizedBox(height: height * 0.008),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Expanded(
                                  child: Text(
                                collectionsItemList[index].name,
                                style: state.textTheme.caption,
                              ))),
                          SizedBox(
                            height: height * 0.04,
                          ),
                          type!.contains("image")
                              ? typeImage(snapshot, context)
                              : type.contains("video")
                                  ? typeVideo(snapshot, context)
                                  : type.contains("html")
                                      ? typeHtml(snapshot, context)
                                      : SizedBox(height: height * 0.2),
                          SizedBox(
                            height: height * 0.048,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Details",
                                style: state.textTheme.subtitle2,
                              )),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Color(0xFF606060)))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Contract Address',
                                          style: state.textTheme.headline4),
                                      SizedBox(
                                        height: height * 0.004,
                                        width: width * 0.4,
                                      ),
                                      Row(children: [
                                        Text(
                                            concatAddress(
                                                collectionsItemList[index]
                                                    .contractAddress),
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: state.textTheme.headline5),
                                      ]),
                                      SizedBox(
                                        width: width * 0.4,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                color: Color(0xFF606060)))),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Token ID',
                                            style: state.textTheme.headline4),
                                      ),
                                      SizedBox(
                                        height: height * 0.004,
                                        width: width * 0.3,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          collectionsItemList[index].id,
                                          style: state.textTheme.headline5,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.3,
                                      )
                                    ])),
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                color: Color(0xFF606060)))),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Token Standard',
                                            style: state.textTheme.headline4),
                                      ),
                                      SizedBox(
                                        height: height * 0.004,
                                        width: width * 0.4,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Número ERC',
                                          style: state.textTheme.headline5,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.4,
                                      )
                                    ])),
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                color: Color(0xFF606060)))),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Blockchain',
                                            style: state.textTheme.headline4),
                                      ),
                                      SizedBox(
                                        height: height * 0.004,
                                        width: width * 0.3,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          isValidEthereumAddress(
                                                      collectionsItemList[index]
                                                          .contractAddress) ==
                                                  true
                                              ? "Ethereum"
                                              : "Bloc Other",
                                          style: state.textTheme.headline5,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.3,
                                      )
                                    ])),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Properties",
                                style: state.textTheme.subtitle2,
                              )),
                          SizedBox(
                            height: height * 0.011,
                          ),
                          Row(
                            children: [
                              Container(
                                  height: height * 0.20,
                                  width: width * 0.47,
                                  decoration: BoxDecoration(
                                      color: state.primaryColorDark,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Column(children: [
                                    SizedBox(
                                      height: height * 0.023,
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: ListView.builder(
                                            itemCount:
                                                collectionsItemList[index]
                                                    .attributes
                                                    .length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, a) {
                                              final nDataList =
                                                  collectionsItemList[index];
                                              return Column(
                                                children: [
                                                  Text(
                                                      nDataList.attributes[a]
                                                                  .traitType !=
                                                              null
                                                          ? nDataList
                                                              .attributes[a]
                                                              .traitType!
                                                          : "",
                                                      style: state
                                                          .textTheme.headline5),
                                                  Text(
                                                      nDataList
                                                          .attributes[a].value!,
                                                      style: state
                                                          .textTheme.headline5),
                                                ],
                                              );
                                            })),
                                  ])),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          )
                        ]),
                      ),
                    ),
                  );
              }
            })
      ])),
    );
  }

  Widget typeImage(AsyncSnapshot<CollectionsItem> snapshot, context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
            onTap: () => Navigator.of(context).push(WhitePageRoute(
                enterPage: NftScreen(collectionsItemList, index))),
            child: snapshot.data!.animationUrl == null
                ? Stack(alignment: Alignment.center, children: [
                    snapshot.data!.image.contains('http')
                        ? CachedNetworkImage(
                      placeholder: (context, url) => CircularProgressIndicator(),
                      fit: BoxFit.cover, imageUrl: snapshot.data!.image,
                    )
                        : Image.file(
                            File(collectionsItemList[index].image),
                            fit: BoxFit.cover,
                          )
                  ])
                : Stack(alignment: Alignment.center, children: [
              CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(),
                fit: BoxFit.cover, imageUrl: snapshot.data!.animationUrl!,
              )
                  ])));
  }

  Widget typeVideo(AsyncSnapshot<CollectionsItem> snapshot, context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
            onTap: () => Navigator.of(context).push(WhitePageRoute(
                enterPage: NftScreen(collectionsItemList, index))),
            child: snapshot.data!.animationUrl == null
                ? Stack(alignment: Alignment.center, children: [
                    snapshot.data!.image.contains('png')
                        ? Image.file(
                            File(collectionsItemList[index].image),
                            fit: BoxFit.cover,
                          )
                        : VideoPlayer(
                            VideoPlayerController.network(snapshot.data!.image))
                  ])
                : Stack(alignment: Alignment.center, children: [
                    VideoPlayer(VideoPlayerController.network(
                        snapshot.data!.animationUrl!))
                  ])));
  }

  Widget typeHtml(AsyncSnapshot<CollectionsItem> snapshot, context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
            onTap: () => Navigator.of(context).push(WhitePageRoute(
                enterPage: NftScreen(collectionsItemList, index))),
            child: snapshot.data!.animationUrl == null
                ? Stack(alignment: Alignment.center, children: [
              CachedNetworkImage(
                placeholder: (context, url) => CircularProgressIndicator(),
                fit: BoxFit.cover, imageUrl: snapshot.data!.image,
              )
                  ])
                : Stack(alignment: Alignment.center, children: [
                    VideoPlayer(VideoPlayerController.network(
                        snapshot.data!.animationUrl!))
                  ])));
  }

  void downloadImage() async {
    var type = collectionsItemList[index].contentType;
    try {
      PermissionStatus status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        try {
          showToast('Check the notification to see progress.');
          if (type!.contains("video")) {
            var imageId = await ImageDownloader.downloadImage(
                collectionsItemList[index].animationUrl!,
                destination: AndroidDestinationType.directoryMovies);
            if (imageId == null) {
              return;
            }
          } else {
            var imageId = await ImageDownloader.downloadImage(
                collectionsItemList[index].image,
                destination: AndroidDestinationType.directoryPictures);

            if (imageId == null) {
              return;
            }
          }
        } on PlatformException catch (error) {
          print(error);
        }
      } else {
        askForPermission();
      }
    } catch (e) {
      print(e);
    }
  }

  void askForPermission() async {
    if (await Permission.storage.request().isGranted) {
      downloadImage();
    } else {
      showToast('Please grant storage permission.');
    }
  }

  void showToast(String content) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);

  void _setWallpaper(BuildContext context) async {
    var type = collectionsItemList[index].contentType;
    if (type!.contains("video")) {
      showToast(
          "Invalid " + collectionsItemList[index].contentType! + " Format.");
    } else {
      var file = await DefaultCacheManager()
          .getSingleFile(collectionsItemList[index].image);
      try {
        final int result =
            await platform.invokeMethod('setWallpaper', file.path);
        print('Wallpaer Updated.... $result');
      } on PlatformException catch (e) {
        print("Failed to Set Wallpaper: '${e.message}'.");
      }
    }
    Navigator.pop(context);
  }

  void showLoadingDialog(BuildContext context, state) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
              onWillPop: _willPopCallback,
              child: AlertDialog(
                backgroundColor: state.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                content: Row(
                  children: <Widget>[
                    CircularProgressIndicator(color: state.cardColor),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Please Wait....',
                          style: state.textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Future<bool> _willPopCallback() async {
    return false;
  }
}
