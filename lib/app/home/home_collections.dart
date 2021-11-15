import 'package:NFT_View/app/home/settings/login_ethereum_address/login_modal_address.dart';
import 'package:NFT_View/app/widgets/flag_list.dart';
import 'package:NFT_View/app/widgets/wallpaper_list.dart';
import 'package:NFT_View/controllers/home/home_collections_controller.dart';
import 'package:NFT_View/core/models/index.dart';
import 'package:NFT_View/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'collections/collections_my_collection.dart';

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
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final navigator = Navigator.of(context);
    final wallpaper = watch(wallpaperProvider.notifier);
    final networkStream = eventChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => event == "disconnected" || event == null ? [].cast<String>() : [event] );


    return Scaffold(
      backgroundColor: state.primaryColor,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            StreamBuilder<dynamic>(
                initialData: dataLogin.listAddress,
                stream: networkStream,
                builder: (context, snapshot) {
                  print(snapshot.data);

                  final List<String> address = snapshot.data != null ? List<String>.from(snapshot.data).length > 0 ? List<String>.from(snapshot.data) : dataLogin.listAddress : [].cast<String>();

                  print("address: $address");
                  if (address.length > 0) {
                    return _connectWidget(dataState, stateTheme, dataStateLogin,
                        navigator, state, context);
                  } else {
                    return FutureBuilder<List<String>>(
                      future: dataStateLogin.sharedWrite(address),
                      // function where you call your api
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        // AsyncSnapshot<Your object type>
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Text('Please wait its loading...', style: state.textTheme.bodyText1,));
                        } else {
                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          else
                            return MyCollectionView();

                        }
                      },
                    );
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
          iconTheme: IconThemeData(color: state.textTheme.bodyText1!.color),
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
                      Text(
                        "Hello!",
                        style: state.textTheme.caption
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        "Your NFT collections will display \n once you connect your wallet.",
                        style: state.textTheme.headline5,
                      ),
                      SizedBox(
                        height: height * 0.095,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          dataStateLogin.openMetaMask();
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            fixedSize: Size((width * 0.90), (height * 0.08))),
                        child: Row(children: [
                          new CircleAvatar(
                            radius: 15.0,
                            backgroundImage:
                                AssetImage('assets/images/walletconnect.png'),
                          ),
                          SizedBox(
                            width: width * 0.10,
                          ),
                          Text(
                            "Use WalletConnect",
                            style: state.textTheme.headline5,
                            textAlign: TextAlign.center,
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
                            fixedSize: Size((width * 0.90), (height * 0.08))),
                        child: Row(
                          children: [
                            new CircleAvatar(
                              radius: 15.0,
                              backgroundImage:
                                  AssetImage('assets/images/ethereum.png'),
                            ),
                            SizedBox(
                              width: width * 0.10,
                            ),
                            Text(
                              "Enter ethereum address",
                              style: state.textTheme.headline5,
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
}
