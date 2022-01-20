import 'dart:io';
import 'package:faktura_nft_viewer/controllers/home/home_collections_controller.dart';
import 'package:faktura_nft_viewer/controllers/home/settings/settings_login_controller.dart';
import 'package:faktura_nft_viewer/app/home/settings/login_modal/login_modal.dart';
import 'package:faktura_nft_viewer/core/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Providers
import 'package:faktura_nft_viewer/core/providers/providers.dart';

import 'login_modal/login_modal.dart';

class SettingsLoginView extends ConsumerWidget {
  final eventChannel =
      const EventChannel("com.bimsina.re_walls/WalletStreamHandler");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final dataState = ref.read(loginProvider.notifier);
    final data = ref.watch(loginProvider);
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final navigator = Navigator.of(context);
    final controller = ref.read(homeCollectionsProvider.notifier);
    final networkStream = eventChannel.receiveBroadcastStream().distinct().map(
        (dynamic event) => event == "disconnected" || event == null
            ? [].cast<String>()
            : [event]);

    return _buildUI(controller, state, data, dataState, _deviceHeight,
        _deviceWidth, navigator, networkStream, context);
  }

  Widget _buildUI(
      controller,
      state,
      SettingsLoginState data,
      SettingsLoginController dataState,
      double _deviceHeight,
      double _deviceWidth,
      navigator,
      networkStream,
      BuildContext context) {
    return Scaffold(
        backgroundColor: state.primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: state.textTheme.bodyText1!.color),
          backgroundColor: state.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: _deviceHeight,
            width: _deviceWidth,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _walletsWidget(
                    controller,
                    state,
                    data,
                    dataState,
                    _deviceHeight,
                    _deviceWidth,
                    navigator,
                    networkStream,
                    context)
              ],
            ),
          ),
        ));
  }

  Widget _walletsWidget(
      controller,
      state,
      SettingsLoginState data,
      SettingsLoginController dataState,
      double _deviceHeight,
      double _deviceWidth,
      navigator,
      networkStream,
      BuildContext context) {
    //SettingsLoginController();
    return Container(
        margin: EdgeInsets.only(
            left: (_deviceWidth * 0.02), right: (_deviceWidth * 0.02)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            Row(
              children: [
                Text(
                  'Wallets',
                  style: TextStyle(
                      color: state.textTheme.bodyText1!.color,
                      decoration: TextDecoration.none,
                      fontFamily: 'MavenPro-Black',
                      fontWeight: FontWeight.w900,
                      fontSize: 40.0),
                ),
              ],
            ),
            SizedBox(
              height: _deviceHeight * 0.024,
            ),
            Row(
              children: [
                Text(
                  'Connected wallet',
                  style: TextStyle(
                    color: state.textTheme.bodyText1!.color,
                    decoration: TextDecoration.none,
                    fontSize: 20.0,
                    fontFamily: "MavenPro-Medium",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: _deviceHeight * 0.008,
            ),
            StreamBuilder<dynamic>(
                initialData: data.listAddress,
                stream: networkStream,
                builder: (context, snapshotStream) {
                  if (List<String>.from(snapshotStream.data).length > 0 &&
                      snapshotStream.connectionState !=
                          ConnectionState.waiting) {
                    return FutureBuilder<List<String>>(
                      future: dataState.sharedWrite(
                          List<String>.from(snapshotStream.data).first),
                      // function where you call your api
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        // AsyncSnapshot<Your object type>
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Text('Please wait its loading...',
                                  style: TextStyle(
                                      color:
                                          state.textTheme.bodyText1!.color)));
                        } else {
                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}',
                                    style: TextStyle(
                                        color:
                                            state.textTheme.bodyText1!.color)));
                          else
                            controller.onRefresh();
                          return _listAddressWidget(
                              controller,
                              state,
                              data,
                              dataState,
                              _deviceHeight,
                              _deviceWidth,
                              navigator,
                              networkStream,
                              context);
                        }
                      },
                    );
                  } else if (data.listAddress.length > 0 &&
                      data.listAddress.isNotEmpty) {
                    controller.onRefresh();
                    return _listAddressWidget(
                        controller,
                        state,
                        data,
                        dataState,
                        _deviceHeight,
                        _deviceWidth,
                        navigator,
                        networkStream,
                        context);
                  } else {
                    //TODO: Replace with empty placeholder
                    return Column(children: [
                      Container(
                          margin: EdgeInsets.only(
                              left: (_deviceWidth * 0.02),
                              right: (_deviceWidth * 0.02)),
                          height: _deviceHeight * 0.09,
                          decoration: BoxDecoration(
                              border: Border.all(color: state.primaryColor),
                              color: state.primaryColorDark,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Container(
                            margin:
                                EdgeInsets.only(left: (_deviceWidth * 0.04)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "No connected wallet",
                                style: state.textTheme.headline5,
                              ),
                            ),
                          )),
                      SizedBox(
                        height: _deviceHeight * 0.018,
                      )
                    ]);
                  }
                }),
            SizedBox(
              height: _deviceHeight * 0.021,
            ),
            Row(
              children: [
                Text(
                  "Add New Wallet",
                  style: TextStyle(
                    color: state.textTheme.bodyText1!.color,
                    decoration: TextDecoration.none,
                    fontSize: 20.0,
                    fontFamily: "MavenPro-SemiBold",
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: _deviceHeight * 0.0104),
            _connectWidget(context, dataState, navigator, state),
          ],
        ));
  }

  Widget _listAddressWidget(
      controller,
      state,
      SettingsLoginState data,
      SettingsLoginController dataState,
      double _deviceHeight,
      double _deviceWidth,
      navigator,
      networkStream,
      BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: (_deviceWidth * 0.02), right: (_deviceWidth * 0.02)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            data.listAddress.length >= 1
                ? _listWalletsWidget(context, data, dataState, state,
                    _deviceHeight, _deviceWidth)
                : SizedBox(
                    height: _deviceHeight * 0.112,
                  ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  data.listAddress.length.toString() + "  " + 'wallets',
                  style: TextStyle(
                    color: state.textTheme.bodyText1!.color,
                    decoration: TextDecoration.none,
                    fontSize: 20.0,
                    fontFamily: "MavenPro-SemiBold",
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
                Spacer(),
                TextButton(
                    onPressed: () {
                      if (data.listAddress.length > 3) {
                        dataState.setExpanded();
                      }
                    },
                    child: Text(
                      "View all",
                      style: TextStyle(
                        color: Colors.orange,
                        decoration: TextDecoration.none,
                        fontSize: 20.0,
                        fontFamily: "MavenPro-SemiBold",
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: _deviceHeight * 0.0242,
            ),
          ],
        ));
  }

  Widget _connectWidget(BuildContext context, dataState, navigator, state) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(left: (width * 0.02), right: (width * 0.02)),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        ElevatedButton(
          onPressed: () {
            dataState.openMetaMask();
          },
          style: TextButton.styleFrom(
              backgroundColor: state.buttonColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              fixedSize: Size((width * 1.1), (height * 0.07))),
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
        SizedBox(
          height: height * 0.008,
        ),
        SizedBox(width: width * 0.005),
        ElevatedButton(
          onPressed: () => showModalAddress(context, state, dataState),
          style: TextButton.styleFrom(
              backgroundColor: state.cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              fixedSize: Size((width * 1.1), (height * 0.07))),
          child: Row(
            children: [
              SvgPicture.asset('assets/images/ethereum.svg',
                  color: state.primaryColor, semanticsLabel: 'Ethereum icon'),
              SizedBox(
                width: width * 0.025,
              ),
              Text(
                "Enter ETH address",
                style: TextStyle(fontSize: 16.0, color: state.primaryColor),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _listWalletsWidget(BuildContext context, SettingsLoginState data,
      SettingsLoginController dataState, state, _deviceHeight, _deviceWidth) {
    return Column(children: [
      ListView.builder(
        shrinkWrap: true,
        itemCount: data.isExpanded == false && data.listAddress.length > 3
            ? 3
            : data.listAddress.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: state.primaryColorDark),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: _deviceWidth * 0.04,
                    ),
                    Text(
                      'Address ',
                      style: TextStyle(
                          color: state.textTheme.bodyText1!.color,
                          fontFamily: "MavenPro-Regular",
                          fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    Expanded(
                        child: Text(
                      concatAddress(data.listAddress[index]),
                      maxLines: 1,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                          color: state.textTheme.bodyText1!.color,
                          fontFamily: "MavenPro-Regular",
                          fontWeight: FontWeight.w400),
                    )),
                    IconButton(
                      onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            final width = MediaQuery.of(context).size.width;
                            final height = MediaQuery.of(context).size.height;

                            return Container(
                                margin: EdgeInsets.only(
                                    left: (width * 0.02),
                                    right: (width * 0.02)),
                                //padding: const EdgeInsets.all(30.0),
                                decoration: BoxDecoration(
                                    color: state.primaryColorDark,
                                    border: Border.all(
                                        color: state.primaryColorDark),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0))),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(height: height * 0.0185),
                                      Row(
                                        children: [
                                          SizedBox(width: width * 0.13),
                                          Text("wallet",
                                              style: state.textTheme.bodyText2),
                                          SizedBox(
                                            width: width * 0.08,
                                          ),
                                          Expanded(
                                              child: Text(
                                                  data.listAddress[index]
                                                              .toString()
                                                              .length >
                                                          8
                                                      ? data.listAddress[index]
                                                          .toString()
                                                          .substring(
                                                              0,
                                                              data.listAddress[
                                                                          index]
                                                                      .toString()
                                                                      .length -
                                                                  8)
                                                      : data.listAddress[index]
                                                          .toString(),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.end,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  style: state
                                                      .textTheme.bodyText2)),
                                          Expanded(
                                              child: Text(
                                            data.listAddress[index]
                                                        .toString()
                                                        .length >
                                                    8
                                                ? data.listAddress[index]
                                                    .toString()
                                                    .substring(data
                                                            .listAddress[index]
                                                            .toString()
                                                            .length -
                                                        8)
                                                : '',
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            softWrap: false,
                                            style: state.textTheme.bodyText2,
                                          )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: (width * 0.04),
                                            right: (width * 0.04)),
                                        child: ElevatedButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    state.primaryColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                fixedSize: Size((width * 1.1),
                                                    (height * 0.08)),
                                                side: BorderSide(
                                                    color: Colors.red),
                                                alignment: Alignment.center),
                                            child: Row(children: [
                                              SizedBox(
                                                width: width * 0.24,
                                              ),
                                              Icon(Icons.delete_outlined,
                                                  color: Colors.red),
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                              Text(
                                                "Remove wallet",
                                                style:
                                                    state.textTheme.headline5,
                                                textAlign: TextAlign.center,
                                              ),
                                            ]),
                                            onPressed: () {
                                              dataState.sharedRemove(
                                                  data.listAddress[index]);
                                              Navigator.pop(context);
                                            }),
                                      ),
                                      SizedBox(height: height * 0.0185),
                                    ]));
                          }),
                      icon: Icon(Platform.isAndroid
                          ? Icons.more_vert
                          : Icons.more_horiz),
                      color: state.textTheme.bodyText1!.color,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _deviceHeight * 0.007,
              ),
            ],
          );
        },
      ),
    ]);
  }
}
