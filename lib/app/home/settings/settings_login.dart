import 'dart:io';
import 'package:faktura_nft_viewer/app/home/settings/login_ethereum_address/login_modal_address.dart';
import 'package:faktura_nft_viewer/app/home/settings/login_modal_connected.dart';
import 'package:faktura_nft_viewer/controllers/home/settings/settings_login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import 'package:faktura_nft_viewer/core/providers/providers.dart';

class SettingsLoginView extends ConsumerWidget {
  final eventChannel =
      const EventChannel("com.bimsina.re_walls/WalletStreamHandler");

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider);
    final dataState = watch(loginProvider.notifier);
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final navigator = Navigator.of(context);
    final networkStream = eventChannel
        .receiveBroadcastStream()
        .distinct()
        .map((dynamic event) => event == "disconnected" || event == null ? [].cast<String>() : [event] );

    return _buildUI(state, dataState, _deviceHeight, _deviceWidth,
        navigator, networkStream, context);
  }

  Widget _buildUI(
      state,
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
                  state,
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
      state,
      SettingsLoginController dataState,
      double _deviceHeight,
      double _deviceWidth,
      navigator,
      networkStream,
      BuildContext context) {
    ModalConnected modalConnected = ModalConnected();

    return Container(
        margin: EdgeInsets.only(left: (_deviceWidth * 0.02), right: (_deviceWidth * 0.02)),
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
              height: _deviceHeight * 0.0175,
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
                initialData: dataState.listAddress,
                stream: networkStream,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  final List<String> address = snapshot.data != null ? List<String>.from(snapshot.data).length > 0 ? List<String>.from(snapshot.data) : dataState.listAddress : [].cast<String>();

                  print("address: $address");
                  if (List<String>.from(snapshot.data).length > 0) {
                    return FutureBuilder<List<String>>(
                      future: dataState.sharedWrite(address),
                      // function where you call your api
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        // AsyncSnapshot<Your object type>
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Text('Please wait its loading...',
                                  style: TextStyle(
                                      color: state
                                          .textTheme.bodyText1!.color)));
                        } else {
                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}',
                                    style: TextStyle(
                                        color: state
                                            .textTheme.bodyText1!.color)));
                          else
                            return _listAddressWidget(
                                state,
                                dataState,
                                _deviceHeight,
                                _deviceWidth,
                                navigator,
                                networkStream,
                                context);
                        }
                      },
                    );
                  } else if (address.length > 0 && address.isNotEmpty) {
                    return _listAddressWidget(
                        state,
                        dataState,
                        _deviceHeight,
                        _deviceWidth,
                        navigator,
                        networkStream,
                        context);
                  } else {
                    //TODO: Replace with empty placeholder
                    return _listAddressWidget(
                        state,
                        dataState,
                        _deviceHeight,
                        _deviceWidth,
                        navigator,
                        networkStream,
                        context);
                  }
                }),
            SizedBox(
              height: 100.0,
            ),
            Row(
              children: [
                Text(
                  "Connect New Wallet",
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

  Widget _listAddressWidget(state,
      SettingsLoginController dataState,
      double _deviceHeight,
      double _deviceWidth,
      navigator,
      networkStream,
      BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: (_deviceWidth * 0.02), right: (_deviceWidth * 0.02)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
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
                        // dataState.listAddress.first,
                        dataState.listAddress.toString().length > 8
                            ? dataState.listAddress.toString().substring(
                            0, dataState.listAddress.toString().length - 8)
                            : dataState.listAddress.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                            color: state.textTheme.bodyText1!.color,
                            fontFamily: "MavenPro-Regular",
                            fontWeight: FontWeight.w400),
                      )),
                  Expanded(
                      child: Text(
                        dataState.listAddress.toString().length > 8
                            ? dataState.listAddress.toString().substring(
                            dataState.listAddress.toString().length - 8)
                            : '',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        softWrap: false,
                        style: TextStyle(
                          color: state.textTheme.bodyText1!.color,
                          fontFamily: "MavenPro-Regular",
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  IconButton(
                    onPressed: () {
                      //_modalConnected(context, state, dataState);
                      //modalConnected.modalConnected(context, state, dataState);
                    },
                    icon: Icon(Platform.isAndroid
                        ? Icons.more_vert
                        : Icons.more_horiz),
                    color: state.textTheme.bodyText1!.color,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _deviceHeight * 0.012,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  dataState.listAddress.length.toString() + "  " + 'wallets',
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
                    onPressed: () {},
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
              height: 100.0,
            ),
          ],
        ));
  }

    Widget _connectWidget(BuildContext context, dataState, navigator, state) {
    ModalAdrress modal = ModalAdrress();
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
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              fixedSize: Size((width * 1.1), (height * 0.08))),
          child: Row(children: [
            new CircleAvatar(
              radius: 15.0,
              backgroundImage: AssetImage('assets/images/walletconnect.png'),
            ),
            SizedBox(
              width: width * 0.10,
            ),
            Text(
              "Use WalletConnect",
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        SizedBox(
          height: height * 0.008,
        ),
        SizedBox(width: width * 0.005),
        ElevatedButton(
          onPressed: () => modal.modalAddress(context, state, dataState),
          style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              fixedSize: Size((width * 1.1), (height * 0.08))),
          child: Row(
            children: [
              new CircleAvatar(
                radius: 15.0,
                backgroundImage: AssetImage('assets/images/ethereum.png'),
              ),
              SizedBox(
                width: width * 0.10,
              ),
              Text(
                "Enter ethereum address",
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ]),
    );
  }
}
