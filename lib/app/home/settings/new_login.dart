import 'package:NFT_View/app/home/settings/login_ethereum_address/login_ethereum_address.dart';
import 'package:NFT_View/core/utils/theme.dart';
import 'package:NFT_View/core/method_channel/conectar.dart';
import 'package:NFT_View/provider/new_login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Initialize NetworkStreamWidget with [key].
  static const String EVENT_CHANNEL_WALLET =
      "com.bimsina.re_walls/WalletStreamHandler";
  final _eventChannel = const EventChannel(EVENT_CHANNEL_WALLET);
  var rest;
  var address;

  @override
  Widget build(BuildContext context) {
    final stateData = Provider.of<ThemeNotifier>(context);
    final ThemeData state = stateData.getTheme();
    return Scaffold(
      backgroundColor: state.primaryColor,
      appBar: AppBar(
        title: Text("Acess Wallet"),
        backgroundColor: state.primaryColor,
        centerTitle: true,
      ),
      body: _buildChild(),
      );
  }

  @override
  Widget _buildChild() {
   // sharedRead();
    if (rest == null) {
      final networkStream = _eventChannel
          .receiveBroadcastStream()
          .distinct()
          .map((dynamic event) => event as String);
      return StreamBuilder<String>(
          initialData: rest.toString(),
          stream: networkStream,
          builder: (context, snapshot) {
            address = snapshot.data ?? null;
            print(address);
            return ListView(padding: EdgeInsets.all(16.0), children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox( height: 40.0,),
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
                      style: TextButton.styleFrom(backgroundColor: Colors.orange,
                          padding: const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0))),
                      child: Row(
                        children: [
                          new CircleAvatar(
                          radius: 15.0,
                        backgroundImage: AssetImage('assets/images/metamask.png'),
                      ),
                          SizedBox(width: 45.0,),
                      Text(
                        "Connect to MetaMask",
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                      ],
                    ),
                      onPressed: () {
                        openMetaMesk();
                        {
                        //  sharedWrite();
                        }
                      },

                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0))),
                      child: Row(
                        children: [
                          new CircleAvatar(
                            radius: 15.0,
                            backgroundImage: AssetImage('assets/images/walletconnect.png'),
                          ),
                          SizedBox(width: 55.0,),
                          Text(
                            "Use WalletConnect",
                            style: TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      onPressed: () {
                        openMetaMesk();
                        {
                          //  sharedWrite();
                        }
                      },

                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.grey,
                          padding: const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0))),
                      child: Row(
                        children: [
                          new CircleAvatar(
                            radius: 15.0,
                            backgroundImage: AssetImage('assets/images/ethereum.png'),
                          ),
                          SizedBox(width: 38.0,),
                          Text(
                            "Enter ethereum address",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginAddress()));
                      },

                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ]);
          });
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              rest,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              //sharedRemove();
              setState(() {});
            },
            child: new Icon(Icons.delete_forever),
          )
        ],
      );
    }
  }
}
