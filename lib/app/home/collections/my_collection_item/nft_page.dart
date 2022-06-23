import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:faktura_nft_viewer/app/home/collections/my_collection_item/nft_screen.dart';
import 'package:faktura_nft_viewer/app/routes/white_page_route.dart';
import 'package:faktura_nft_viewer/app/widgets/html.dart';
import 'package:faktura_nft_viewer/app/widgets/video.dart';
import 'package:faktura_nft_viewer/controllers/home/collections/item/item_nft.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:faktura_nft_viewer/core/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class NftPageView extends ConsumerWidget {
  final List<CollectionsItem> collectionsItemList;
  final int index;

  static const platform =
      const MethodChannel('com.bimsina.re_walls/MainActivity');

  NftPageView(this.collectionsItemList, this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final dataState = ref.read(itemNftProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    var type = collectionsItemList[index].contentType;
    var selected = collectionsItemList[index];
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
              showAlertDialog2(context, state, width);
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
                sharePicture(type);
            },
          ),
        ],
        iconTheme: state.primaryIconTheme,
        elevation: 0.0,
      ),
      backgroundColor: state.primaryColor,
      body: SingleChildScrollView(
          child: Column(children: [
        SingleChildScrollView(
          child: Container(
            margin:
                EdgeInsets.only(left: (width * 0.02), right: (width * 0.02)),
            child: Column(children: [
              SizedBox(height: height * 0.008),
              Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      collectionsItemList[index]
                          .name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: state.textTheme.caption,
                    ),
                  ),),
              SizedBox(
                height: height * 0.04,
              ),
              type!.contains("image")
                  ? typeImage(collectionsItemList[index], context, dataState)
                  : type.contains("video")
                      ? typeVideo(
                          collectionsItemList[index], context, dataState)
                      : type.contains("html")
                          ? typeHtml(
                              collectionsItemList[index], context, dataState)
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
                              right: BorderSide(color: Color(0xFF606060)))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    collectionsItemList[index].contractAddress),
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
                                right: BorderSide(color: Color(0xFF606060)))),
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
                                right: BorderSide(color: Color(0xFF606060)))),
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
                                right: BorderSide(color: Color(0xFF606060)))),
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
                              isValidEthereumAddress(collectionsItemList[index]
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
              properties(height, width, state, selected),
              SizedBox(
                height: height * 0.01,
              )
            ]),
          ),
        )
      ])),
    );
  }

  Widget properties(height, width, state, selected) {
    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                      ),
                       itemCount: collectionsItemList[index].attributes.length,
                      itemBuilder: (context, index) {
                        //final nDataList = collectionsItemList[index];
                        return Container(
                          height: height * 0.0744,
                          decoration: BoxDecoration(
                              color: state.primaryColorDark,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Center(
                              child:Container(
                        margin: EdgeInsets.all(4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                 Text(
                                     selected.attributes[index].traitType != null ? selected.attributes[index].traitType :
                                     "",
                                    style: state.textTheme.headline5),
                              SizedBox(
                                height: height * 0.012,
                              ),
                              Text(
                                  selected.attributes[index].value != null ? selected.attributes[index].value :
                                  "",
                                      style: state.textTheme.headline5),
                            ],
                          )),
                          ));
                      }
    );
  }

  Widget typeImage(
      CollectionsItem snapshot, context, ItemNftController dataState) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
            onTap: () {
              dataState.setReset();
              Navigator.of(context).push(WhitePageRoute(
                  enterPage: NftScreen(collectionsItemList, index)));
            },
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
                  ])));
  }

  Widget typeVideo(
      CollectionsItem snapshot, context, ItemNftController dataState) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
            onTap: () {
              dataState.setReset();
              Navigator.of(context).push(WhitePageRoute(
                  enterPage: NftScreen(collectionsItemList, index)));
            },
            child: snapshot.animationUrl == null
                ? Stack(
                alignment: Alignment.center, children: [
                    snapshot.image.contains('png')
                        ? Image.file(
                            File(collectionsItemList[index].image),
                            fit: BoxFit.cover,
                          )
                        :  VideoWidget(collectionsItemList, index)
                  ])
                : VideoWidget(collectionsItemList, index)));
  }

  Widget typeHtml(
      CollectionsItem snapshot, context, ItemNftController dataState) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
            onTap: () {
              dataState.setReset();
              Navigator.of(context).push(WhitePageRoute(
                  enterPage: NftScreen(collectionsItemList, index)));
            },
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
                    children: [HtmlWidget(collectionsItemList, index)])));
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

  void showToast(String content) => Fluttertoast.showToast(
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
  Future<void> sharePicture(type) async {
    String imageurl = '';
    if (type!.contains("video")) {
      imageurl = '${collectionsItemList[index].animationUrl!}';
    }else{
      imageurl = '${collectionsItemList[index].image}';
    }
    final uri = Uri.parse(imageurl);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path], text: 'Checkout this amazing NFT mine.');
  }
}
