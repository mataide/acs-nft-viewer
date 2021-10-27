import 'package:NFT_View/app/home/settings/login_ethereum_address/login_ethereum_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

import 'login_wallet_connect.dart';

class SettingsLoginView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider);
    final dataState = watch(loginProvider.notifier);
    final data = watch(loginProvider);


    if (data.rest == "") {
      return Scaffold(
        backgroundColor: state.primaryColor,
        appBar: AppBar(
          title: Text("Acess Wallet"),
          backgroundColor: state.primaryColor,
          centerTitle: true,
        ),
        body: ListView(padding: EdgeInsets.all(16.0), children: [
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
                        backgroundImage:
                            AssetImage('assets/images/metamask.png'),
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
                    {openMetaMesk();
                    WalletController.EVENT_CHANNEL_WALLET;}
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
                    openMetaMesk();
                    WalletController.EVENT_CHANNEL_WALLET;
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
                        backgroundImage:
                            AssetImage('assets/images/ethereum.png'),
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginAddress()));
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ]),
      );
    } else {
      return Scaffold(
          backgroundColor: state.primaryColor,
          appBar: AppBar(
            title: Text("Acess Wallet"),
            backgroundColor: state.primaryColor,
            centerTitle: true,
          ),
          body: Row(
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
                onPressed: () {
                  dataState.sharedRemove();
                },
                child: new Icon(Icons.delete_forever),
              )
            ],
          ));
    }
  }
}
