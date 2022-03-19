import 'package:faktura_nft_viewer/app/home/settings/login_modal/login_modal.dart';
import 'package:faktura_nft_viewer/app/widgets/flag_list.dart';
import 'package:faktura_nft_viewer/controllers/home/home_collections_controller.dart';
import 'package:faktura_nft_viewer/controllers/home/settings/settings_login_controller.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class HomeCollectionsView extends ConsumerWidget {
  final eventChannel =
      const EventChannel("com.bimsina.re_walls/WalletStreamHandler");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final dataState = ref.watch(homeCollectionsProvider);
    final stateTheme = ref.watch(themeProvider);
    final stateLogin = ref.watch(loginProvider);
    //Controllers
    final controllerLogin = ref.read(loginProvider.notifier);
    final controller = ref.read(homeCollectionsProvider.notifier);
    final navigator = Navigator.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final networkStream = eventChannel.receiveBroadcastStream().distinct().map(
        (dynamic event) => event == "disconnected" || event == null
            ? [].cast<String>()
            : [event]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: state.primaryColor,
        iconTheme: state.primaryIconTheme,
        elevation: 0.0,
      ),
      backgroundColor: state.primaryColor,
      body: _pullToRefresh(controller, dataState, stateTheme, stateLogin, controllerLogin,
          navigator, state, context, networkStream, width, height,)
    );
  }

  Widget _pullToRefresh(
      HomeCollectionsController controller,
      HomeCollectionsState dataState,
      stateTheme,
      stateLogin,
      SettingsLoginController controllerLogin,
      navigator,
      state,
      BuildContext context,
      networkStream,
      width,
      height,) {
    return SmartRefresher(
      enablePullDown: true,
      //enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context,LoadStatus? mode){
          Widget body ;
          if(mode==LoadStatus.idle){
            body =  Text("Load more");
          }
          else if(mode==LoadStatus.loading){
            body =  CupertinoActivityIndicator();
          }
          else if(mode == LoadStatus.failed){
            body = Text("Load Failed!Click retry!");
          }
          else if(mode == LoadStatus.canLoading){
            body = Text("release to load more");
          }
          else{
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child:body),
          );
        },
      ),
      controller: dataState.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: _connectWidget(controller, dataState, stateTheme, stateLogin, controllerLogin,
          navigator, state, context, networkStream, width, height,),
      );
  }


  Widget _connectWidget(
      HomeCollectionsController controller,
      HomeCollectionsState dataState,
      stateTheme,
      stateLogin,
      SettingsLoginController controllerLogin,
      navigator,
      state,
      BuildContext context,
      networkStream,
      width,
      height,
      ) {
    SettingsLoginController();
    return ListView(children: [
      SizedBox(
        height: height * 0.02,
      ),
      Text(
        'M Y  C O L L E C T I O N S',
        style: state.textTheme.caption,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: height * 0.05),
      StreamBuilder<dynamic>(
          initialData: stateLogin.listAddress,
          stream: networkStream,
          builder: (context,AsyncSnapshot snapshot) {
            print(snapshot.data);
            final List<String> address = snapshot.data != null
                ? List<String>.from(snapshot.data).length > 0
                ? List<String>.from(snapshot.data)
                : stateLogin.listAddress
                : [].cast<String>();
            if (List<String>.from(snapshot.data).length > 0) {
              return FutureBuilder<List<String>>(
                future: controllerLogin.sharedRead(),
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
                      return SizedBox(
                        height: height * 0.012,
                      );
                  }
                },
              );
            } else if (address.isNotEmpty) {
              return SizedBox(
                height: height * 0.012,
              );
            } else {
              return _connectedWidget(
                  controller,
                  dataState,
                  stateTheme,
                  stateLogin,
                  controllerLogin,
                  navigator,
                  state,
                  context,
                  networkStream,
                  width,
                  height);
            }
          }),
      Column(children: [
        Row(children: <Widget>[
          Container(
              child: Expanded(
                child: FutureBuilder<List<Collections>>(
                    future: controller.prepareFromDb(),
                    // function where you call your api
                    builder:
                        (BuildContext context, AsyncSnapshot snapshot) {
                      final images = snapshot.data;
                      // AsyncSnapshot<Your object type>
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator(color: state.hoverColor,));
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
    ]);
  }

  Widget _connectedWidget(
      HomeCollectionsController controller,
      HomeCollectionsState dataState,
      stateTheme,
      stateLogin,
      SettingsLoginController controllerLogin,
      navigator,
      state,
      BuildContext context,
      networkStream,
      width,
      height) {
    //controller.prepareFromDb();
    return Container(
        margin: EdgeInsets.only(left: (width * 0.02), right: (width * 0.02)),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
                color: state.primaryColorDark,
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: height * 0.032),
                  Text("You've made it!", style: state.textTheme.caption),
                  SizedBox(height: height * 0.02),
                  Text(
                    "Your NFT collections will display \n once you connect your wallet.",
                    style: state.textTheme.headline5,
                  ),
                  SizedBox(
                    height: height * 0.032,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.0225, right: width * 0.0225),
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAnalytics.instance.logEvent(name: 'MetaMesk',parameters:null);
                        controllerLogin.openMetaMask();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: state.indicatorColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          fixedSize: Size((width * 0.90), (height * 0.07))),
                      child: Row(children: [
                        SvgPicture.asset('assets/images/walletconnect.svg',
                            color: Colors.white,
                            semanticsLabel: 'Wallet Connect icon',
                            width: 24),
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
                  ),
                  SizedBox(
                    height: height * 0.008,
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: width * 0.0225, right: width * 0.0225),
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseAnalytics.instance.logEvent(
                              name: 'Eth_Address', parameters: null);
                          showModalAddress(context, state, controllerLogin);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: state.cardColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            fixedSize: Size((width * 0.90), (height * 0.07))),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/eth_address.svg',
                                color: state.primaryColor,
                                semanticsLabel: 'Ethereum icon'),
                            SizedBox(
                              width: width * 0.025,
                            ),
                            Text(
                              "Enter ethereum address",
                              style: TextStyle(fontSize: 16.0, color: state.primaryColor),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: height * 0.011,
                  ),
                ]),
          ),
          SizedBox(
            height: height * 0.022,
          ),
          Row(children: <Widget>[
            Text(
              "E X A M P L E S",
              style: state.textTheme.subtitle2,
              textAlign: TextAlign.left,
            ),
          ]),
          SizedBox(
            height: height * 0.012,
          )
        ]));
  }
}
