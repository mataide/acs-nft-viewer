import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faktura_nft_viewer/app/widgets/html.dart';
import 'package:faktura_nft_viewer/app/widgets/video.dart';
import 'package:faktura_nft_viewer/controllers/home/collections/item/item_nft.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class NftScreen extends ConsumerWidget {
  final List<CollectionsItem> collectionsItemList;
  final int index;
  static const platform =
      const MethodChannel('com.bimsina.re_walls/MainActivity');

  NftScreen(this.collectionsItemList, this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var type = collectionsItemList[index].contentType;
    final dataState = ref.read(itemNftProvider.notifier);
    final data = ref.watch(itemNftProvider);

    dataState.setDelay();
    return Scaffold(
        backgroundColor: state.primaryColor,
        body: Center(
        child:  data.isVisibility == true ?
                type!.contains("image")
                    ? GestureDetector(
                    onTap: () {
                      dataState.setVisibility();
                    },
                    child: Stack(
                    children: [ typeImage(collectionsItemList[index], context, dataState),
                    Positioned(
                    top: 8.0,
                    left: 2.0,
                    child: iconsAction(
                        context, state, width, type, height, dataState))]))
                        : type.contains("video")
                        ? Align(alignment: Alignment.center, child: typeVideo(
                        collectionsItemList[index], context, dataState))
                        : type.contains("html")
                        ? typeHtml(
                        collectionsItemList[index], context, dataState):SizedBox(height: height * 0.2)
        :GestureDetector(
            onTap: () {
              dataState.setVisibility();
            },
            child:
                 type!.contains("image")
                    ? typeImage(collectionsItemList[index], context, dataState)
                    : type.contains("video")
                    ? typeVideo(
                    collectionsItemList[index], context, dataState)
                    : type.contains("html")
                    ? typeHtml(
                    collectionsItemList[index], context, dataState):SizedBox(height: height * 0.2),)));
  }

  /*Future<bool> _getFutureBool(ItemNftController dataState) {
    return Future.delayed(Duration(seconds: 2)).then((value) => dataState.setVisibility());
  }*/

  Widget iconsAction(BuildContext context, state, width, type, height,
      ItemNftController dataState) {
    return Row(
      children: [
        SizedBox(
          height: height * 0.063,
        ),
        Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: state.primaryColor),
            child: IconButton(
                icon: SvgPicture.asset(
                  'assets/images/exit.svg',
                  semanticsLabel: 'Exit icon',
                  color: state.cardColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })),
        SizedBox(
          width: width * 0.41,
        ),
        Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: state.primaryColor),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/images/wallpaper.svg',
                semanticsLabel: 'Wallpaper icon',
                color: state.cardColor,
              ),
              onPressed: () async {
                showAlertDialog2(context, state, width);
              },
            )),
        SizedBox(
          width: width * 0.03,
        ),
        Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: state.primaryColor),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/images/download.svg',
                semanticsLabel: 'Download icon',
                color: state.cardColor,
              ),
              onPressed: () {
                downloadImage();
              },
            )),
        SizedBox(
          width: width * 0.03,
        ),
        Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: state.primaryColor),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/images/share.svg',
                semanticsLabel: 'Share icon',
                color: state.cardColor,
              ),
              onPressed: () {
                if (type!.contains("video")) {
                  Share.share(
                      'Checkout this amazing NFT mine. ${collectionsItemList[index].animationUrl}');
                } else {
                  Share.share(
                      'Checkout this amazing NFT mine. ${collectionsItemList[index].image}');
                }
              },
            )),
        SizedBox(
          width: width * 0.03,
        ),
      ],
    );
  }

  Widget typeImage(
      CollectionsItem snapshot, context, ItemNftController dataState) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: snapshot.animationUrl == null
                ? Stack(alignment: Alignment.center, children: [
              snapshot.image.contains('http')
                  ? CachedNetworkImage(
                placeholder: (context, url) =>
                    CircularProgressIndicator(),
                fit: BoxFit.cover,
                imageUrl: snapshot.image,
              )
                  : Image.file(
                File(collectionsItemList[index].image),
                fit: BoxFit.cover,
              )
            ])
                : Stack(alignment: Alignment.center, children: [
              CachedNetworkImage(
                placeholder: (context, url) =>
                    CircularProgressIndicator(),
                fit: BoxFit.cover,
                imageUrl: snapshot.animationUrl!,
              )
            ]));
  }

  Widget typeVideo(
      CollectionsItem snapshot, context, ItemNftController dataState) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: snapshot.animationUrl == null
                ? Stack(alignment: Alignment.center, children: [
              snapshot.image.contains('png')
                  ? Image.file(
                File(collectionsItemList[index].image),
                fit: BoxFit.cover,
              )
                  : Stack(
                  alignment: Alignment.center,
                  children: [VideoWidget(collectionsItemList, index)])
            ])
                : Stack(
                alignment: Alignment.center,
                children: [VideoWidget(collectionsItemList, index)]));
  }

  Widget typeHtml(
      CollectionsItem snapshot, context, ItemNftController dataState) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: snapshot.animationUrl == null
                ? Stack(alignment: Alignment.center, children: [
              CachedNetworkImage(
                placeholder: (context, url) =>
                    CircularProgressIndicator(),
                fit: BoxFit.cover,
                imageUrl: snapshot.image,
              )
            ])
                : Stack(
                alignment: Alignment.center,
                children: [HtmlWidget(collectionsItemList, index)]));
  }
  void downloadImage() async {
    var type = collectionsItemList[index].contentType;
    try {
      PermissionStatus status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        try {
          showToast('Check the notification to see progress.');
          if (type!.contains("video") || type.contains("html")) {
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

  void showToast(
    String content,
  ) =>
      Fluttertoast.showToast(
          msg: content,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);

  void _setWallpaper(BuildContext context) async {
    var file = await DefaultCacheManager()
        .getSingleFile(collectionsItemList[index].image);
    try {
      final int result =
      await platform.invokeMethod('setWallpaper', file.path);
      print('Wallpaper Updated.... $result');
    } on PlatformException catch (e) {
      print("Failed to Set Wallpaper: '${e.message}'.");
    }
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

  showAlertDialog2(BuildContext context, state, width) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: state.primaryColor,
            title: Center(
                child: Text("Change Set Wallpaper ?",
                    style: state.textTheme.headline4)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: state.buttonColor,
                            padding: EdgeInsets.all(8.0)),
                        child: Text("Yes", style: state.textTheme.headline4),
                        onPressed: () async {
                          var type = collectionsItemList[index].contentType;
                          if (type!.contains("video") || type.contains("html")) {
                            showToast(
                                "Invalid " + collectionsItemList[index].contentType! + " Format.");
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            _setWallpaper(context);
                          }},
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: state.buttonColor),
                          child: Text("No", style: state.textTheme.headline4),
                          onPressed: () => Navigator.pop(context)),
                    ])
              ],
            ),
          );
        });
  }

  Future<bool> _willPopCallback() async {
    return false;
  }
}
