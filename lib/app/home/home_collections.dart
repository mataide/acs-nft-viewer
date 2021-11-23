import 'dart:io';

import 'package:faktura_nft_viewer/app/home/settings/login_ethereum_address/login_modal_address.dart';
import 'package:faktura_nft_viewer/app/widgets/flag_list.dart';
import 'package:faktura_nft_viewer/controllers/home/home_collections_controller.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'collections/collections_my_collection.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeCollectionsView extends ConsumerWidget {
  final eventChannel =
      const EventChannel("com.bimsina.re_walls/WalletStreamHandler");

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider);
    final dataState = watch(homeCollectionsProvider.notifier);
    final stateTheme = watch(themeProvider);
    final dataStateLogin = watch(loginProvider.notifier);
    final dataLogin = watch(loginProvider);
    final navigator = Navigator.of(context);
    final flagState = watch(flagListProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final networkStream = eventChannel.receiveBroadcastStream().distinct().map(
        (dynamic event) => event == "disconnected" || event == null
            ? [].cast<String>()
            : [event]);

    return Scaffold(
      backgroundColor: state.primaryColor,
      body: Container(
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            StreamBuilder<dynamic>(
                initialData: dataStateLogin.listAddress,
                stream: networkStream,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  final List<String> address = snapshot.data != null
                      ? List<String>.from(snapshot.data).length > 0
                          ? List<String>.from(snapshot.data)
                          : dataLogin.listAddress
                      : [].cast<String>();

                  print("address: $address");
                  if(List<String>.from(snapshot.data).length > 0){
                    return FutureBuilder<List<String>>(
                      future: dataStateLogin.sharedWrite(address),
                      // function where you call your api
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        // AsyncSnapshot<Your object type>
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Text(
                            'Please wait its loading...',
                            style: state.textTheme.bodyText1,
                          ));
                        } else {
                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          else
                            return _connectedWidget(
                                dataState, width, height, flagState, state);
                        }
                      },
                    );
                  } else {
                    return _connectWidget(dataState, stateTheme, dataStateLogin,
                        navigator, state, context);
                  }
                  })
          ],
        ),
      ),
    );
  }

  Widget _connectWidget(HomeCollectionsController dataState, stateTheme,
      dataStateLogin, navigator, state, BuildContext context) {
    ModalAdrress modal = ModalAdrress();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: state.primaryColor,
          iconTheme: state.primaryIconTheme,
        ),
        body: Container(
            margin:
                EdgeInsets.only(left: (width * 0.02), right: (width * 0.02)),
            child: ListView(children: [
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                'My Collections',
                style: state.textTheme.caption,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: height * 0.05),
              Container(
                decoration: BoxDecoration(
                    color: state.primaryColorDark,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: height * 0.032),
                      Text("Hello!", style: state.textTheme.caption),
                      SizedBox(height: height * 0.02),
                      Text(
                        "Your NFT collections will display \n once you connect your wallet.",
                        style: state.textTheme.headline5,
                      ),
                      SizedBox(
                        height: height * 0.032,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          dataStateLogin.openMetaMask();
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            fixedSize: Size((width * 0.90), (height * 0.07))),
                        child: Row(children: [
                          SvgPicture.asset(
                              'assets/images/walletconnect.svg',
                              semanticsLabel: 'Wallet Connect icon',
                              width: 24
                          ),
                          SizedBox(
                            width: width * 0.025,
                          ),
                          Text(
                            "Use WalletConnect",
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.left,
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: height * 0.008,
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            modal.modalAddress(context, state, dataState),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            fixedSize: Size((width * 0.90), (height * 0.07))),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                'assets/images/ethereum.svg',
                                color: Colors.white,
                                semanticsLabel: 'Ethereum icon'
                            ),
                            SizedBox(
                              width: width * 0.025,
                            ),
                            Text(
                              "Enter ethereum address",
                              style: TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.011,
                      ),
                    ]),
              ),
              SizedBox(
                height: height * 0.022,
              ),
              Text(
                "Examples",
                textAlign: TextAlign.left,
                style: state.textTheme.caption,
              ),
              SizedBox(
                height: height * 0.012,
              ),
              Column(children: [
                Row(children: <Widget>[
                  Container(
                      child: Expanded(
                    child: FutureBuilder<List<Collections>>(
                        future: dataState.prepareFromDb(),
                        // function where you call your api
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          final images = snapshot.data;
                          // AsyncSnapshot<Your object type>
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                        'prepareFromDb error: ${snapshot.error}'));
                              } else {
                                return FlagListWidget(images);
                              }
                          }
                        }),
                  )),
                  SizedBox(
                    width: width * 0.02,
                  ),
                ])
              ])
            ])));
  }

  Widget _connectedWidget(
      HomeCollectionsController dataState, width, height, flagState, state) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: state.primaryIconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(
                    left: (width * 0.02), right: (width * 0.02)),
                child: Column(children: [
                  SizedBox(height: height * 0.008),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My Collections",
                        style: state.textTheme.caption,
                      )),
                  SizedBox(
                    height: height * 0.017,
                  ),
                  Column(children: [
                    Row(children: <Widget>[
                      Container(
                          child: Expanded(
                        child: FutureBuilder<List<Collections>>(
                            future: dataState.prepareFromDb(),
                            // function where you call your api
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              final images = snapshot.data;
                              // AsyncSnapshot<Your object type>
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
                                default:
                                  if (snapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            'prepareFromDb error: ${snapshot.error}'));
                                  } else {
                                    return GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          crossAxisCount: 2,
                                        ),
                                        itemCount: images.length,
                                        itemBuilder: (context, index) {
                                          return FutureBuilder<String>(
                                            future:
                                                flagState.prepareFromDb(
                                                    images[index]),
                                            // function where you call your api
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              // AsyncSnapshot<Your object type>
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                    child: Text(
                                                  'Please wait its loading...',
                                                  style: TextStyle(
                                                      color: state.textTheme
                                                          .bodyText1!.color),
                                                ));
                                              } else {
                                                if (snapshot.hasError)
                                                  return Center(
                                                      child: Text(
                                                          'getCollectionImage: ${snapshot.error}'));
                                                else
                                                  return GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyCollectionView()));
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: snapshot
                                                                    .data!
                                                                    .contains(
                                                                        'http')
                                                                ? Image.network(
                                                                    snapshot
                                                                        .data!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Image.file(
                                                                    File(snapshot
                                                                        .data!),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                          ),
                                                          Positioned(
                                                              bottom: 30.0,
                                                              left: 20.0,
                                                              child: Text(images[
                                                                      index]
                                                                  .tokenName)),
                                                          Positioned(
                                                              bottom: 10.0,
                                                              left: 20.0,
                                                              child: Text(
                                                                  '${images[index].totalSupply}')),
                                                        ],
                                                      ));
                                              }
                                            },
                                          );
                                        });
                                  }
                              }
                            }),
                      )),
                      SizedBox(
                        width: width * 0.02,
                      ),
                    ])
                  ])
                ]))));
  }
}
