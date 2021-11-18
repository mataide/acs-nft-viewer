import 'dart:io';

import 'package:faktura_nft_viewer/app/home/collections/nft_page.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';

class MyCollectionView extends ConsumerWidget {
  @override
  Widget build(
    BuildContext context,
    ScopedReader watch,
  ) {
    final state = watch(themeProvider);
    final dataState = watch(homeCollectionsProvider.notifier);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final wall = watch(wallpaperListProvider.notifier);

    final List<Collections> collectionsList;

    return Scaffold(
        appBar: AppBar(
          iconTheme: state.primaryIconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
            colors: [Colors.brown, Colors.black54, Colors.black],
            center: Alignment.topCenter,
          )),
          child: Column(
            children: [
              SizedBox(height: height * 0.024),
              SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.only(
                          left: (width * 0.02), right: (width * 0.02)),
                      child: Column(children: [
                        SizedBox(height: height * 0.008),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Nome da Coleção",
                              style: state.textTheme.caption,
                            )),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Author',
                              style: state.textTheme.caption,
                              textAlign: TextAlign.start,
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "BUSCAR DA API O NOME DO AUTOR",
                              style: state.textTheme.headline5,
                              textAlign: TextAlign.start,
                            )),
                        SizedBox(
                          height: height * 0.016,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "About",
                              style: state.textTheme.caption,
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: ReadMoreText(
                              "BUSCAR DA API DESCRIÇÃO DA COLEÇÃOsdfffffffffffffffffffffffffffffffffffffff"
                              "sfddddddddddddddddddddddddddddddddddddddddddddddddddddddd"
                              "dsfsfawwwwwwwwwwwwwwwwwwwwwwwwwtreeeeeeeeeehhhhhhhhhhhhhdsfwefwefwerfreferferferfefergfdgbdfsbdfsbdfsb"
                              "dfsdafsdkjflhnhnhnhnhnhnhnhnhnhnhnhnhnhnhnhnhnsadiçwafwerrrrrrrrrf"
                              "wefkençççççççççççççççççoiiiiiiiiiiiiiiiiiiioíiiiiii"
                              "sdfjnnnnnnnnnnnnnnnnnnnnnn",
                              style: state.textTheme.headline5,
                              trimLines: 4,
                              colorClickableText: Colors.green,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Read more',
                              trimExpandedText: 'Read less',
                              textAlign: TextAlign.left,
                              // delimiterStyle: TextStyle(color: Colors.green),
                              // moreStyle: TextStyle(color: Colors.green),
                            )),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Owned',
                              style: state.textTheme.caption,
                            )),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        _owned(
                          context,
                          dataState,
                          state,
                          width,
                          wall,
                        ),
                        /*Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'More NFTs',
                              style: state.textTheme.caption,
                            )),*/
                        SizedBox(
                          height: height * 0.01,
                        ),
                        //_more(context, dataState, flagState, state, width),
                      ])))
            ],
          ),
        )));
  }

  Widget _owned(context, dataState, state, width, wall) {
    return Column(children: [
      Row(children: <Widget>[
        Container(
            child: Expanded(
                child: SingleChildScrollView(
          child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
              ),
              itemCount: 3,
              itemBuilder: (context, index) {
                return FutureBuilder<String>(
                  future: wall.getCollectionItem(wall.collections),
                  // function where you call your api
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    // AsyncSnapshot<Your object type>
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Text(
                        'Please wait its loading...',
                        style:
                            TextStyle(color: state.textTheme.bodyText1!.color),
                      ));
                    } else {
                      if (snapshot.hasError)
                        return Center(
                            child:
                                Text('getCollectionImage: ${snapshot.error}'));
                      else
                        return GestureDetector(
                            onTap: () {
                              NftPageView();
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: snapshot.data!.contains('http')
                                      ? Image.network(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(snapshot.data!),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                    bottom: 30.0,
                                    left: 20.0,
                                    child: Text(
                                        wall.collections[index].tokenName)),
                                Positioned(
                                    bottom: 10.0,
                                    left: 20.0,
                                    child: Text(
                                        '${wall.collections[index].totalSupply}')),
                              ],
                            ));
                    }
                  },
                );
              }),
        ))),
        SizedBox(
          width: width * 0.02,
        ),
      ]),
    ]);
  }

/* Widget _more(context, dataState, flagState, state, width) {
    return Column(children: [
      Row(children: <Widget>[
        Container(
            child: Expanded(
          child: FutureBuilder<List<Collections>>(
              future: dataState.prepareFromDb(),
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
                          child:
                              Text('prepareFromDb error: ${snapshot.error}'));
                    } else {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            crossAxisCount: 3,
                          ),
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder<String>(
                              future:
                                  flagState.getCollectionImage(images[index]),
                              // function where you call your api
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                // AsyncSnapshot<Your object type>
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: Text(
                                    'Please wait its loading...',
                                    style: TextStyle(
                                        color:
                                            state.textTheme.bodyText1!.color),
                                  ));
                                } else {
                                  if (snapshot.hasError)
                                    return Center(
                                        child: Text(
                                            'getCollectionImage: ${snapshot.error}'));

                                  return GestureDetector(
                                      onTap: () {
                                        print('apertado');
                                      },
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child:
                                                snapshot.data!.contains('http')
                                                    ? Image.network(
                                                        snapshot.data!,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        File(snapshot.data!),
                                                        fit: BoxFit.cover,
                                                      ),
                                          ),
                                          Positioned(
                                              bottom: 30.0,
                                              left: 20.0,
                                              child: Text(
                                                  images[index].tokenName)),
                                          Positioned(
                                              bottom: 10.0,
                                              left: 20.0,
                                              child: Text(
                                                  '${images[index].totalSupply}')),
                                        ],
                                      ));
                                }
                              },
                            );
                          });
                    }
                }
              }),
        )),
        SizedBox(
          width: width * 0.02,
        ),
      ])
    ]);*/
}
