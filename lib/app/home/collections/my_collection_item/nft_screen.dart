import 'dart:async';
import 'dart:io';

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
    final controller =
        ref.read(wallpaperListProvider(collectionsItemList).notifier);
    final state = ref.watch(themeProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var type = collectionsItemList[index].contentType;
    final dataState = ref.read(itemNftProvider.notifier);
    final data = ref.watch(itemNftProvider);

  dataState.setDelay();
    return Scaffold(
        backgroundColor: state.primaryColor,
        body: Align(
            alignment: Alignment.center,
        child: Positioned(
            child: GestureDetector(
              onTap: (){
                dataState.setVisibility();
              },
              child:
            Stack(
          children: [
            Container(
              child: collectionsItemList[index].image.contains('http')
                  ? Image.network(collectionsItemList[index].image,
                      fit: BoxFit.fitWidth)
                  : Image.file(
                      File(collectionsItemList[index].image),
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
            ),
           Container(child:
           data.isVisibility == true ?
             iconsAction(context, state, width, type,height,dataState)
             : Container()
                 ),
               ],
        )))));
  }

  /*Future<bool> _getFutureBool(ItemNftController dataState) {
    return Future.delayed(Duration(seconds: 2)).then((value) => dataState.setVisibility());
  }*/

  Widget iconsAction(BuildContext context, state, width, type,height,ItemNftController dataState){
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
              dataState.setVisibility();
              Navigator.pop(context);
    }
          )),
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
                    'Checkout this amazing NFT mine. ${collectionsItemList[index]
                        .animationUrl}');
              } else {
                Share.share(
                    'Checkout this amazing NFT mine. ${collectionsItemList[index]
                        .image}');
              }
            },
          )),
      SizedBox(
        width: width * 0.03,
      ),
    ],
  );
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
                collectionsItemList[index].animationUrl!,
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
            )
    );

  }

  showAlertDialog2(BuildContext context, state, width) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: state.primaryColor,
            title: Center(child: Text("Change Set Wallpaper ?", style:state.textTheme.headline4)),
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
                          Navigator.pop(context);
                          showLoadingDialog(context, state);
                          await Future.delayed(Duration(milliseconds: 1000));
                          _setWallpaper(context);
                        },
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
