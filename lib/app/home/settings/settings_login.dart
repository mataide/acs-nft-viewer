import 'dart:io';
import 'package:NFT_View/app/home/settings/login_ethereum_address/login_modal_address.dart';
import 'package:NFT_View/controllers/home/settings/settings_login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

class SettingsLoginView extends ConsumerWidget {
  final eventChannel =
      const EventChannel("com.bimsina.re_walls/WalletStreamHandler");

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider);
    final dataState = watch(loginProvider.notifier);
    final data = watch(loginProvider);
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final navigator = Navigator.of(context);
    final networkStream =
        eventChannel.receiveBroadcastStream().distinct().map((dynamic event) {
      return event;
    });

    return _buildUI(state, dataState, data, _deviceHeight, _deviceWidth,
        navigator, networkStream, context);
  }

  Widget _buildUI(
      state,
      SettingsLoginController dataState,
      data,
      double _deviceHeight,
      double _deviceWidth,
      navigator,
      networkStream,
      BuildContext context) {
    return Scaffold(
        backgroundColor: state.primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: state.textTheme.bodyText1!.color),
          title: Text(
            "Access Wallet",
            style: TextStyle(
                fontFamily: 'MavenPro-Medium', fontWeight: FontWeight.w900),
          ),
          backgroundColor: state.primaryColor,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: _deviceHeight,
            width: _deviceWidth,
            child: Stack(
              alignment: Alignment.center,
              children: [
                StreamBuilder<dynamic>(
                    initialData: data.listAddress,
                    stream: networkStream,
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      final List<String> address =
                          snapshot.data ?? data.listAddress;
                      print("address: $address");
                      if (address.length > 0) {
                        return _listViewWidget(
                            state,
                            dataState,
                            data,
                            _deviceHeight,
                            _deviceWidth,
                            navigator,
                            networkStream,
                            context);
                      } else {
                        return FutureBuilder<List<String>>(
                          future: dataState.sharedWrite(address),
                          // function where you call your api
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshot) {
                            // AsyncSnapshot<Your object type>
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: Text('Please wait its loading...'));
                            } else {
                              if (snapshot.hasError)
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              else
                                return _connectedWidget(
                                    state,
                                    dataState,
                                    snapshot.data,
                                    _deviceHeight,
                                    _deviceWidth,
                                    navigator,
                                    networkStream,
                                    context);
                            }
                          },
                        );
                      }
                    })
              ],
            ),
          ),
        ));
  }

  Widget _listViewWidget(
      state,
      SettingsLoginController dataState,
      data,
      double _deviceHeight,
      double _deviceWidth,
      navigator,
      networkStream,
      BuildContext context) {
    ModalAdrress modal = ModalAdrress();
    return ListView(padding: EdgeInsets.all(16.0), children: [
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            SizedBox(
              height: 35.0,
            ),
            Text(
              "Connect with wallet \n\n Your NFT collections will \n"
              "appear here as soon as you \n connect with your wallet",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 70.0,
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0))),
              child: Row(
                children: [
                  new CircleAvatar(
                    radius: 15.0,
                    backgroundImage: AssetImage('assets/images/metamask.png'),
                  ),
                  SizedBox(
                    width: 45.0,
                  ),
                  Text(
                    "Connect to MetaMask",
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: () {
                dataState.openMetaMask();
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0))),
              child: Row(
                children: [
                  new CircleAvatar(
                    radius: 15.0,
                    backgroundImage:
                        AssetImage('assets/images/walletconnect.png'),
                  ),
                  SizedBox(
                    width: 55.0,
                  ),
                  Text(
                    "Use WalletConnect",
                    style: TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: () {
                dataState.openMetaMask();
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0))),
              child: Row(
                children: [
                  new CircleAvatar(
                    radius: 15.0,
                    backgroundImage: AssetImage('assets/images/ethereum.png'),
                  ),
                  SizedBox(
                    width: 38.0,
                  ),
                  Text(
                    "Enter ethereum address",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              onPressed: () => modal.modalAddress(context, state, dataState),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _connectedWidget(
      state,
      SettingsLoginController dataState,
      data,
      double _deviceHeight,
      double _deviceWidth,
      navigator,
      networkStream,
      BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 15.0,
        ),
        Row(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Wallets',
              style: TextStyle(
                  color: state.textTheme.bodyText1!.color,
                  decoration: TextDecoration.none,
                  fontFamily: 'MavenPro-Medium',
                  fontWeight: FontWeight.w500,
                  fontSize: 40.0),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Connected wallet',
              style: TextStyle(
                color: state.textTheme.bodyText1!.color,
                decoration: TextDecoration.none,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: state.textTheme.bodyText1!.color),
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 10.0,
              ),
              Text(
                'Address ',
                style: TextStyle(color: state.textTheme.bodyText1!.color),
              ),
              Spacer(),
              Expanded(
                  child: Text(
                //dataState.listAddress.toString(),
                dataState.listAddress.toString().length > 8
                    ? dataState.listAddress.toString().substring(
                        0, dataState.listAddress.toString().length - 8)
                    : dataState.listAddress.toString(),
                maxLines: 1,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                     style: TextStyle(color: state.textTheme.bodyText1!.color),
              )),
              Expanded(
                  child: Text(
                dataState.listAddress.toString().length > 8
                    ? dataState.listAddress
                        .toString()
                        .substring(dataState.listAddress.toString().length - 8)
                    : '',
                maxLines: 1,
                textAlign: TextAlign.start,
                softWrap: false,
                    style: TextStyle(color: state.textTheme.bodyText1!.color),
              )),
              IconButton(
                onPressed: () {
                  _modalConnected(context, state, dataState);
                },
                icon: Icon(
                    Platform.isAndroid ? Icons.more_vert : Icons.more_horiz),
                color: state.textTheme.bodyText1!.color,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 10.0,
            ),
            Text(
              dataState.listAddress!.length.toString() + "  " + 'wallets',
              style: TextStyle(
                color: state.textTheme.bodyText1!.color,
                decoration: TextDecoration.none,
                fontSize: 20.0,
              ),
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  "View all",
                  style: TextStyle(
                    color: Colors.orange,
                    decoration: TextDecoration.none,
                    fontSize: 20.0,
                  ),
                )),
          ],
        ),
        SizedBox(
          height: 40.0,
        ),
        _connectWidget(context, dataState, navigator, state),
      ],
    );
  }

  Widget _modalConnected(BuildContext context, state, dataState) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              margin: EdgeInsets.only(
                  left: 7.0, right: 7.0, bottom: 1.0, top: 15.0),
              //padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                  border: Border.all(color: state.primaryColor),
                  borderRadius: BorderRadius.circular(30.0)),
              child: Wrap(children: <Widget>[
                Row(
                  children: [
                    Spacer(),
                    Text("wallet"),
                    Expanded(
                        child: Text(
                      dataState.listAddress.toString().length > 8
                          ? dataState.listAddress.toString().substring(
                              0, dataState.listAddress.toString().length - 8)
                          : dataState.listAddress.toString(),
                      maxLines: 1,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
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
                    )),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                Center(
                    child: SizedBox(
                  width: 350,
                  height: 62,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: state.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        side: BorderSide(color: Colors.red)),
                    child: Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 95.0),
                            child: Row(children: [
                              Icon(Icons.delete_outlined, color: Colors.red),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Remove wallet",
                                style: TextStyle(
                                    color: state.textTheme.bodyText1!.color),
                              ),
                            ]))),
                    onPressed: () {},
                  ),
                )),
                SizedBox(
                  height: 90,
                ),
              ]));
        });
    return Container();
  }

  Widget _connectWidget(BuildContext context, dataState, navigator, state) {
    ModalAdrress modal = ModalAdrress();
    return Container(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        ElevatedButton(
          onPressed: () {
            dataState.openMetaMask();
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0))),
          child: Row(children: [
            new CircleAvatar(
              radius: 15.0,
              backgroundImage: AssetImage('assets/images/walletconnect.png'),
            ),
            SizedBox(
              width: 55.0,
            ),
            Text(
              "Use WalletConnect",
              style: TextStyle(fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        SizedBox(
          height: 10.0,
        ),
        ElevatedButton(
          onPressed: () => modal.modalAddress(context, state, dataState),
          style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
              padding: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0))),
          child: Row(
            children: [
              new CircleAvatar(
                radius: 15.0,
                backgroundImage: AssetImage('assets/images/ethereum.png'),
              ),
              SizedBox(
                width: 38.0,
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
