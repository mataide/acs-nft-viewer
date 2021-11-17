import 'package:NFT_View/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class NftPageView extends ConsumerWidget {
  final eventChannel =
      const EventChannel("com.bimsina.re_walls/WalletStreamHandler");

  @override
  Widget build(
    BuildContext context,
    ScopedReader watch,
  ) {
    final state = watch(themeProvider);
    final dataState = watch(homeCollectionsProvider.notifier);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    String TESTE = '12345678910111213';
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.wallpaper,
                color: state.textTheme.caption.color,
              ),
              onPressed: () {
                _setWallpaper();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.download_outlined,
                color: state.textTheme.caption.color,
              ),
              onPressed: () {
                // downloadImage();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: state.textTheme.caption.color,
              ),
              onPressed: () {
                // Share.share(
                // 'Checkout this amazing NFT mine. ${currentPost.url}');
              },
            ),
          ],
          iconTheme: state.primaryIconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Column(children: [
            SizedBox(height: height * 0.024),
            SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.only(
                        left: (width * 0.02), right: (width * 0.02)),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.008),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "tokenName",
                              style: state.textTheme.caption,
                            )),
                        SizedBox(
                          height: height * 0.016,
                        ),
                        SizedBox(
                            height: height * 0.55,
                            width: width,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset('assets/images/metamask.png'),
                              ],
                            )),
                        SizedBox(
                          height: height * 0.048,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Details",
                              style: TextStyle(
                                  color: state.textTheme.caption.color,
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
                                  color: state.textTheme.headline5.color,
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
                                  TESTE.length > 15
                                      ? TESTE.substring(0, 6)
                                      : TESTE,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: state.textTheme.headline5)),
                          Text(TESTE.length > 15 ? '.........' : ""),
                          Text(
                            TESTE.length > 15
                                ? TESTE.substring(TESTE.length - 4)
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
                                  color: state.textTheme.headline5.color,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'FuturaPTMedium.otf',
                                  fontSize: 16.0)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Número Token',
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
                                  color: state.textTheme.headline5.color,
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
                                  color: state.textTheme.headline5.color,
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
                    )))
          ]),
        )));
  }

  // FALTA MEXER NAS FUNÇÕES

  /*void downloadImage() async {
    try {
      PermissionStatus status = await Permission.storage.status;

      if (status == PermissionStatus.granted) {
        try {
          showToast('Check the notification to see progress.');

          var imageId = await ImageDownloader.downloadImage(currentPost.url,
             destination: AndroidDestinationType.directoryDownloads);
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
  }*/

  /* void askForPermission() async {
    if (await Permission.storage.request().isGranted) {
      downloadImage();
    } else {
      showToast('Please grant storage permission.');
    }
  }*/

  void _setWallpaper() async {
    //var file = await DefaultCacheManager().getSingleFile(currentPost.url);
    try {
      //final int result = await eventChannel.invokeMethod('setWallpaper', file.path);
      //print('Wallpaer Updated.... $result');
    } on PlatformException catch (e) {
      print("Failed to Set Wallpaer: '${e.message}'.");
    }
    // Navigator.pop(context);
  }

  void showToast(String content, state) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: state.primaryColor,
      textColor: state.testTheme.bodyText1!,
      fontSize: 16.0);
}
