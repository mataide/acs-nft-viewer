import 'package:NFT_View/app/home/collections/collections.dart';
import 'package:NFT_View/app/home/settings/login_ethereum_address/login_ethereum_address.dart';
import 'package:NFT_View/core/models/api_model.dart';
import 'package:NFT_View/core/providers/api_provider.dart';
import 'package:NFT_View/core/providers/login_provider.dart';
import 'package:NFT_View/core/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginCollections extends ConsumerWidget {
  final eventChannel =
      const EventChannel("com.bimsina.re_walls/WalletStreamHandler");

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ThemeData state = watch(themeProvider.notifier).state;
    final dataState = watch(apiProvider.notifier);
    final stateTheme = watch(themeProvider);
    final dataStateLogin = watch(loginProvider.notifier);
    final dataLogin = watch(loginProvider);
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final navigator = Navigator.of(context);
    final networkStream =
        eventChannel.receiveBroadcastStream().distinct().map((dynamic event) {
      return event;
    });

    return Scaffold(
      backgroundColor: state.primaryColor,
      appBar: AppBar(
        title: Text('My collections'),
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
                initialData: dataLogin.listAddress,
                stream: networkStream,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  final List<String> address =
                      snapshot.data ?? dataLogin.listAddress;
                  print("address: $address");
                  if (address.length > 0) {
                    return _connectWidget(
                        dataState, stateTheme, dataStateLogin, navigator);
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
                              child: Text('Please wait its loading...'));
                        } else {
                          if (snapshot.hasError)
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          else
                            return CollectionsView();
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

  Widget _connectWidget(dataState, stateTheme, dataStateLogin, navigator) {
    return ListView(
        padding:
            EdgeInsets.only(left: 10.0, top: 70.0, right: 10.0, bottom: 150.0),
        children: [
          Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "You've made it! \n\n Your NFT collections will \n appear here as soon as you \n connect with your wallet."),
                  SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      dataStateLogin.openMetaMask();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0))),
                    child: Row(children: [
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
                    ]),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      navigator.push(MaterialPageRoute(
                          builder: (context) => LoginAddress()));
                    },
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
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ]),
          ),
          Text(
            "Example",
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 28.0,
          ),
          Column(children: [
            Row(children: <Widget>[
              Container(
                  child: Expanded(
                child: FutureBuilder<List<DataModel>?>(
                    future: dataState.getData(),
                    // function where you call your api
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      final users = snapshot.data;
                      // AsyncSnapshot<Your object type>
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return Center(child: Text('Some error occured!'));
                          } else {
                            return _buildImages(users);
                          }
                      }
                    }),
              )),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FutureBuilder<List<DataModel>?>(
                    future: dataState.getData(),
                    // function where you call your api
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      final images = snapshot.data;
                      // AsyncSnapshot<Your object type>
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return _buildImages(images);
                          }
                      }
                    }),
              )
            ])
          ])
        ]);
  }

  Widget _buildImages(List<DataModel> images) => ListView.builder(
        shrinkWrap: true,
        //Se passa para 2 o itemCount ele coloca a 1ª e 2ª imagem da Api uma embaixo da outra dos dois lados,
        // e não a 1ª de um lado e a 2ª do outro
        itemCount: 2,
        itemBuilder: (context, index) {
          final image = images[index];
          return Stack(
            //shrinkWrap: true,
            children: [Image.network(image.url)],
          );
        },
      );
}
