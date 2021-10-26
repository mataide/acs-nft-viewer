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
    final viewModel = watch(apiProvider);

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
                        onPressed: () {},
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
                          child: viewModel.listDataModel.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: 1,
                                  //itemCount: viewModel.listDataModel.length,
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(18.0),
                                      child: ListView(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        children: [
                                          Image.network(
                                            viewModel.listDataModel[index].url
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                    );
                                  }))),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                      child: Expanded(
                          child: viewModel.listDataModel.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: viewModel.listDataModel.length,
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(18.0),
                                      child: ListView(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        children: [
                                          Image.network(
                                            viewModel.listDataModel[index].url
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                    );
                                  }))),
                ])
              ])
            ]));
  }
}
