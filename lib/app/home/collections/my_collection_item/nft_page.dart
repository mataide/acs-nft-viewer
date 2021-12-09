import 'dart:io';
import 'package:faktura_nft_viewer/app/home/collections/my_collection_item/nft_screen.dart';
import 'package:faktura_nft_viewer/app/routes/slide_right_route.dart';
import 'package:faktura_nft_viewer/app/routes/white_page_route.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
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
        backgroundColor: state.primaryColor,
        actionsIconTheme: IconThemeData(color: state.cardColor),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset('assets/images/wallpaper.svg',
          semanticsLabel: 'Wallpaper icon',
              color: state.textTheme.caption!.color,
            ),
            onPressed: () async {
              showLoadingDialog(context, state);
              await Future.delayed(Duration(seconds: 1));
              _setWallpaper(context);
            },
          ),
          IconButton(
            icon: SvgPicture.asset('assets/images/download.svg',
              semanticsLabel: 'Download icon',
              color: state.textTheme.caption!.color,
            ),
            onPressed: () {
              downloadImage();
            },
          ),
          IconButton(
            icon: SvgPicture.asset('assets/images/share.svg',
              semanticsLabel: 'Share icon',
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child:
                              GestureDetector(
                                  onTap:()=> Navigator.of(context).push(WhitePageRoute(enterPage: NftScreen(collectionsItemList,index))),
                                  child:
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  snapshot.data!.image!.contains('http')
                                      ? Image.network(
                                          snapshot.data!.image!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(collectionsItemList[index]
                                              .image!),
                                          fit: BoxFit.cover,
                                        ),
                                ],
                              )
                          )),
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
                                            style: state.textTheme.headline5),
                                        Text(
                                          collectionsItemList[index]
                                                      .contractAddress
                                                      .length >
                                                  15
                                              ? '.........'
                                              : "",
                                          style: state.textTheme.headline5,
                                        ),
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
                                        ),
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
                                          'Bloc ETH',
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
                                  height: height * 0.14,
                                  width: width * 0.47,
                                  decoration: BoxDecoration(
                                      color: state.primaryColorDark,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'BODY',
                                          style: state.textTheme.bodyText2,
                                        ),
                                        Text(
                                          'Blue Cat Skin',
                                          style: state.textTheme.headline5,
                                        ),
                                        Text(
                                          '100% have this trait',
                                          style: state.textTheme.subtitle1,
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Container(
                                  height: height * 0.14,
                                  width: width * 0.47,
                                  decoration: BoxDecoration(
                                      color: state.primaryColorDark,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'FACE',
                                          style: state.textTheme.bodyText2,
                                        ),
                                        Text(
                                          'Angry Cut',
                                          style: state.textTheme.headline5,
                                        ),
                                        Text(
                                          '3% have this trait',
                                          style: state.textTheme.subtitle1,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              Container(
                                  height: height * 0.14,
                                  width: width * 0.47,
                                  decoration: BoxDecoration(
                                      color: state.primaryColorDark,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'SHIRT',
                                          style: state.textTheme.bodyText2,
                                        ),
                                        Text(
                                          'Pirate Red',
                                          style: state.textTheme.headline5,
                                        ),
                                        Text(
                                          '0.6% have this trait',
                                          style: state.textTheme.subtitle1,
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Container(
                                height: height * 0.14,
                                width: width * 0.47,
                                decoration: BoxDecoration(
                                    color: state.primaryColorDark,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'HATS',
                                        style: state.textTheme.bodyText2,
                                      ),
                                      Text(
                                        'Cupcake',
                                        style: state.textTheme.headline5,
                                      ),
                                      Text(
                                        '1% have this trait',
                                        style: state.textTheme.subtitle1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            children: [
                              Container(
                                height: height * 0.14,
                                width: width * 0.47,
                                decoration: BoxDecoration(
                                    color: state.primaryColorDark,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'TIER',
                                        style: state.textTheme.bodyText2,
                                      ),
                                      Text(
                                        'Wild 2',
                                        style: state.textTheme.headline5,
                                      ),
                                      Text(
                                        '12% have this trait',
                                        style: state.textTheme.subtitle1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: width * 0.02,
                            height: height * 0.01,
                          ),
                        ],
                      ),
                    )),
                  );
              }
            })
      ])),
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
