import 'dart:io';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
    final dataState = ref.watch(wallpaperListProvider(collectionsItemList));
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:state.primaryColor,
        actionsIconTheme: IconThemeData(color: state.cardColor),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.wallpaper,
              color: state.textTheme.caption!.color,
            ),
            onPressed: () async {
              showLoadingDialog(context, state);
              await Future.delayed(Duration(seconds: 1));
              _setWallpaper(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.download_outlined,
              color: state.textTheme.caption!.color,
            ),
            onPressed: () {
              downloadImage();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: state.textTheme.caption!.color,
            ),
            onPressed: () {
              Share.share(
                  'Checkout this amazing NFT mine. ${collectionsItemList[index].image}');
            },
          ),
        ],
        iconTheme: state.primaryIconTheme,
        elevation: 0.0,
      ),
      body: Container(
        color: state.primaryColor,
          child:  SingleChildScrollView(
            child:
          FutureBuilder<CollectionsItem>(
                    future: controller
                        .getCollectionItem(collectionsItemList[index]),
                    // function where you call your api
                    builder: (BuildContext context,
                        AsyncSnapshot<CollectionsItem> snapshot) {
                      // AsyncSnapshot<Your object type>
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Text(
                          'Please wait its loading...',
                          style: TextStyle(
                              color: state.textTheme.bodyText1!.color),
                        ));
                      } else {
                        if (snapshot.hasError)
                          return Center(
                              child: Text(
                                  'getCollectionImage: ${snapshot.error}'));
                        else
                          return SingleChildScrollView(
                            child: Expanded(
                              child:
                            Container(
                              margin: EdgeInsets.only(
                                  left: (width * 0.02), right: (width * 0.02)),
                              child: Column(
                                children: [
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
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          snapshot.data!.image!.contains('http')
                                              ? Image.network(
                                                  snapshot.data!.image!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  File(collectionsItemList[
                                                          index]
                                                      .image!),
                                                  fit: BoxFit.cover,
                                                ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: height * 0.048,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Details",
                                        style: TextStyle(
                                            color:
                                                state.textTheme.caption!.color,
                                            fontSize: 20.0,
                                            fontFamily: 'FuturaPTBold.otf',
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  SizedBox(
                                    height: height * 0.012,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Contract Address',
                                        style: TextStyle(
                                            color: state
                                                .textTheme.headline5!.color,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'FuturaPTMedium.otf',
                                            fontSize: 16.0)),
                                  ),
                                  SizedBox(
                                    height: height * 0.004,
                                  ),
                                  Row(children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            collectionsItemList[index]
                                                        .contractAddress
                                                        .length >
                                                    15
                                                ? collectionsItemList[index]
                                                    .contractAddress
                                                    .substring(0, 6)
                                                : collectionsItemList[index]
                                                    .contractAddress,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: state.textTheme.headline5)),
                                    Text(collectionsItemList[index]
                                                .contractAddress
                                                .length >
                                            15
                                        ? '.........'
                                        : ""),
                                    Text(
                                      collectionsItemList[index]
                                                  .contractAddress
                                                  .length >
                                              15
                                          ? collectionsItemList[index]
                                              .contractAddress
                                              .substring(
                                                  collectionsItemList[index]
                                                          .contractAddress
                                                          .length -
                                                      4)
                                          : '',
                                      maxLines: 1,
                                      //textAlign: TextAlign.start,
                                      softWrap: false,
                                      style: state.textTheme.headline5,
                                    )
                                  ]),
                                  SizedBox(
                                    height: height * 0.012,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Token ID',
                                        style: TextStyle(
                                            color: state
                                                .textTheme.headline5!.color,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'FuturaPTMedium.otf',
                                            fontSize: 16.0)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      collectionsItemList[index].id,
                                      style: state.textTheme.headline5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.012,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Token Standard',
                                        style: TextStyle(
                                            color: state
                                                .textTheme.headline5!.color,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'FuturaPTMedium.otf',
                                            fontSize: 16.0)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Número ERC',
                                      style: state.textTheme.headline5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.012,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Blockchain',
                                        style: TextStyle(
                                            color: state
                                                .textTheme.headline5!.color,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'FuturaPTMedium.otf',
                                            fontSize: 16.0)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Bloc ETH',
                                      style: state.textTheme.headline5,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          );
                      }

              }))),
    );
  }


  void downloadImage() async {
    try {
      PermissionStatus status = await Permission.storage.status;

      if (status == PermissionStatus.granted) {
        try {
          showToast('Check the notification to see progress.');

          var imageId = await ImageDownloader.downloadImage(
              collectionsItemList[index].image!,
              destination: AndroidDestinationType.directoryPictures);

          if (imageId == null) {
            return;
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
    var file = await DefaultCacheManager()
       .getSingleFile(collectionsItemList[index].image!);
    try {
      final int result = await platform.invokeMethod('setWallpaper', file.path);
      print('Wallpaer Updated.... $result');
    } on PlatformException catch (e) {
      print("Failed to Set Wallpaper: '${e.message}'.");
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
