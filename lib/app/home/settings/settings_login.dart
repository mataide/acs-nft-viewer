import 'package:NFT_View/app/home/settings/login_ethereum_address/login_ethereum_address.dart';
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
        navigator, networkStream);
  }

  Widget _buildUI(state, SettingsLoginController dataState, data,
      double _deviceHeight, double _deviceWidth, navigator, networkStream) {
    return Scaffold(
      backgroundColor: state.primaryColor,
      appBar: AppBar(
        title: Text("Access Wallet"),
        backgroundColor: state.primaryColor,
        centerTitle: true,
      ),
      body: Container(
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
                    return _listViewWidget(state, dataState, data,
                        _deviceHeight, _deviceWidth, navigator, networkStream);
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
                                networkStream);
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

  Widget _listViewWidget(state, SettingsLoginController dataState, data,
      double _deviceHeight, double _deviceWidth, navigator, networkStream) {
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
              onPressed: () {
                navigator.push(
                    MaterialPageRoute(builder: (context) => LoginAddress()));
              },
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _connectedWidget(state, SettingsLoginController dataState, data,
      double _deviceHeight, double _deviceWidth, navigator, networkStream) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            "Connected",
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        ElevatedButton(
          onPressed: () async {
            //dataState.sharedRemove();
          },
          child: new Icon(Icons.delete_forever),
        )
      ],
    );
  }
}
