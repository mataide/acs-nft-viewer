import 'package:faktura_nft_viewer/app/widgets/card_list.dart';
import 'package:faktura_nft_viewer/app/widgets/my_flexible_spacebar.dart';
import 'package:faktura_nft_viewer/app/widgets/wallpaper_list.dart';
import 'package:faktura_nft_viewer/controllers/home/collections/collections_item_controller.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'dart:io';

class CollectionsItemView extends ConsumerWidget {
  final Collections collections;

  CollectionsItemView(this.collections);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final controller = ref.read(collectionsItemProvider(collections).notifier);
    final dataState = ref.watch(collectionsItemProvider(collections));

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: state.primaryColor,
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: state.primaryColor,
                  flexibleSpace: MyFlexibleSpaceBar(
                    centerTitle: false,
                    stretchModes: [StretchMode.blurBackground],
                    title: Text(
                      dataState.collections.tokenName,
                      style: state.textTheme.caption,
                    ),
                    background: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: dataState.collections.image.contains('http')
                          ? Image.network(
                        dataState.collections.image,
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        File(dataState.collections.image),
                        height: MediaQuery.of(context).size.width / 3,
                        fit: BoxFit.cover,
                      ),
                    ),
                    titlePaddingTween: EdgeInsetsTween(
                        begin: EdgeInsets.only(left: 16.0, bottom: 16),
                        end: EdgeInsets.only(left: 72.0, bottom: 16)),
                    key: Key(dataState.collections.tokenName),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
                child: Container(
                  child: Column(
                children: [
                  SizedBox(height: height * 0.024),
                  SingleChildScrollView(
                      child: Container(
                          margin: EdgeInsets.only(
                              left: (width * 0.02), right: (width * 0.02)),
                          child: Column(children: [
                            SizedBox(height: height * 0.008),
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
                                  dataState.collections.description,
                                  style: state.textTheme.subtitle1,
                                  trimLines: 4,
                                  colorClickableText: state.buttonColor,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Read more',
                                  trimExpandedText: 'Read less',
                                  textAlign: TextAlign.left,
                                  moreStyle: TextStyle(
                                      fontFamily: 'FuturaPTBold.otf',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff770955),
                                      fontSize: 14),
                                  lessStyle: TextStyle(
                                      fontFamily: 'FuturaPTBold.otf',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff770955),
                                      fontSize: 14),
                                  // delimiterStyle: TextStyle(color: Colors.green),
                                  // moreStyle: TextStyle(color: Colors.green),
                                )),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Owned',
                                  style: state.textTheme.caption,
                                )),
                            _owned(
                              context,
                              controller,
                              dataState,
                              state,
                              width,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            //_more(context, dataState, flagState, state, width),
                          ])))
                ],
              ),
            ))));
  }

  Widget _owned(
      context, CollectionsItemController controller, dataState, state, width) {
    return Column(children: [
      Row(children: <Widget>[
        Container(
            child: Expanded(
                child: SingleChildScrollView(
          child: FutureBuilder<List<CollectionsItem>>(
            future: controller.prepareFromDb(),
            // function where you call your api
            builder: (BuildContext context,
                AsyncSnapshot<List<CollectionsItem>> snapshot) {
              // AsyncSnapshot<Your object type>
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Text(
                  'Please wait its loading...',
                  style: TextStyle(color: state.textTheme.bodyText1!.color),
                ));
              } else {
                if (snapshot.hasError)
                  return Center(
                      child: Text('getCollectionImage: ${snapshot.error}'));
                else
                  return WallpaperListWidget(snapshot.data!);
              }
            },
          ),
        ))),
      ]),
    ]);
  }
}
