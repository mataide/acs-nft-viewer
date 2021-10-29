import 'package:NFT_View/core/models/api_model.dart';
import 'package:NFT_View/core/providers/api_provider.dart';
import 'package:NFT_View/core/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginCollections extends ConsumerWidget {
  const LoginCollections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ThemeData state = watch(themeProvider.notifier).state;
    final data = watch(apiProvider);
    final dataState = watch(apiProvider.notifier);

    return Scaffold(
        backgroundColor: state.primaryColor,
        appBar: AppBar(
          title: Text('My collections'),
          backgroundColor: state.primaryColor,
          centerTitle: true,
        ),
        body: ListView(
            padding: EdgeInsets.only(
                left: 10.0, top: 70.0, right: 10.0, bottom: 150.0),
            children: [
              _connectWidget(),
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
                        future: dataState.getData(context),
                        // function where you call your api
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          final users = snapshot.data;
                          // AsyncSnapshot<Your object type>
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Some error occured!'));
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
                        future: dataState.getData(context),
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
                                    child: Text('Some error occured!'));
                              } else {
                                return _buildImages(images);
                              }
                          }
                        }),
                  )
                ])
              ])
            ]));
  }

  Widget _connectWidget() {
    return Container(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
            "You've made it! \n\n Your NFT collections will \n appear here as soon as you \n connect with your wallet."),
        SizedBox(
          height: 30.0,
        ),
        ElevatedButton(
          onPressed: () {},
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
          onPressed: () {},
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
