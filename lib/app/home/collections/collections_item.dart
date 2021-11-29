import 'package:faktura_nft_viewer/app/widgets/wallpaper_list.dart';
import 'package:faktura_nft_viewer/controllers/home/collections/collections_item_controller.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';

class CollectionsItemView extends ConsumerWidget {
  final Collections collections;

  CollectionsItemView(this.collections);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final controller = ref.read(collectionsItemProvider(collections).notifier);
    final dataState = ref.watch(collectionsItemProvider(collections));
    final wall = ref.watch(wallpaperListProvider.notifier);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                              dataState.collections.tokenName,
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
                              dataState.collections.description,
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
                          controller,
                          dataState,
                          state,
                          width,
                          wall,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        //_more(context, dataState, flagState, state, width),
                      ])))
            ],
          ),
        )));
  }

  Widget _owned(context,CollectionsItemController controller, dataState, state, width, wall) {
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
        SizedBox(
          width: width * 0.02,
        ),
      ]),
    ]);
  }
}
