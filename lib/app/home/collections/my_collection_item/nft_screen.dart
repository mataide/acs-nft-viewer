import 'dart:io';

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

    return Scaffold(
        backgroundColor: state.primaryColor,
        body: Stack(
          children: [
            Container(
              child: FutureBuilder<CollectionsItem>(
                  future:
                      controller.getCollectionItem(collectionsItemList[index]),
                  // function where you call your api
                  builder: (BuildContext context,
                      AsyncSnapshot<CollectionsItem> snapshot) {
                    // AsyncSnapshot<Your object type>
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Text(
                        'Please wait its loading...',
                        style:
                            TextStyle(color: state.textTheme.bodyText1!.color),
                      ));
                    } else {
                      if (snapshot.hasError)
                        return Center(
                            child:
                                Text('getCollectionImage: ${snapshot.error}'));
                      else
                        return snapshot.data!.image!.contains('http')
                            ? Image.network(snapshot.data!.image!,
                                height: double.infinity, fit: BoxFit.fill)
                            : Image.file(
                                File(collectionsItemList[index].image!),
                                height: double.infinity,
                                fit: BoxFit.fill,
                              );
                    }
                  }),
            ),
            Positioned(
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                //actionsIconTheme: IconThemeData(color: state.cardColor),
                actions: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: state.accentColor),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/exit.svg',
                          semanticsLabel: 'Exit icon',
                          color: state.textTheme.caption!.color,
                        ),
                        onPressed: () => Navigator.pop(context),
                      )),
                  SizedBox(
                    width: width * 0.41,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: state.accentColor),
                      child: IconButton(
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
                      )),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: state.accentColor),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/download.svg',
                          semanticsLabel: 'Download icon',
                          color: state.textTheme.caption!.color,
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
                          shape: BoxShape.circle, color: state.accentColor),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/share.svg',
                          semanticsLabel: 'Share icon',
                          color: state.textTheme.caption!.color,
                        ),
                        onPressed: () {
                          if (type!.contains("video")) {
                            Share.share(
                                'Checkout this amazing NFT mine. ${collectionsItemList[index].video}');
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
                // iconTheme: state.primaryIconTheme,
                elevation: 0.0,
              ),
            )
          ],
        ));
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
                collectionsItemList[index].video!,
                destination: AndroidDestinationType.directoryMovies);
            if (imageId == null) {
              return;
            }
          } else {
            var imageId = await ImageDownloader.downloadImage(
                collectionsItemList[index].video!,
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
          .getSingleFile(collectionsItemList[index].image!);
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
