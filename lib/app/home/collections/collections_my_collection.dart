import 'package:NFT_View/core/models/index.dart';
import 'package:NFT_View/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';

import '../home_collections.dart';

class MyCollectionView extends ConsumerWidget {
  List<CollectionsItem> get collectionsItemList => collectionsItemList;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(themeProvider);
    final dataState = watch(homeCollectionsProvider.notifier);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
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
                            child: Text("Nome da Coleção",
                                style: TextStyle(
                                  color: state.textTheme.bodyText2!.color,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ))),
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
                              style: state.textTheme.bodyText1,
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
                              "dsfsfawwwwwwwwwwwwwwwwwwwwwwwwwtreeeeeeeeeehhhhhhhhhhhhhdsfwefwefwerfreferferferfefer",
                              style: TextStyle(
                                  color: state.textTheme.bodyText1!.color),
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
                      ])))
            ],
          ),
        ));
  }
}
