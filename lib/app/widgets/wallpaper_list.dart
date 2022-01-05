import 'package:faktura_nft_viewer/app/home/collections/my_collection_item/nft_page.dart';
import 'package:faktura_nft_viewer/app/routes/white_page_route.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class WallpaperListWidget extends ConsumerWidget {
  final List<CollectionsItem> collectionsItemList;

  WallpaperListWidget(this.collectionsItemList);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(wallpaperListProvider(collectionsItemList).notifier);
    final dataState = ref.watch(wallpaperListProvider(collectionsItemList));
    final state = ref.watch(themeProvider);

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
          child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
              ),
              itemCount: dataState.collectionsItemList.length,
              itemBuilder: (context, index) {
                return FutureBuilder<CollectionsItem>(
                  future: controller.getCollectionItem(collectionsItemList[index]),
                  // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<CollectionsItem> snapshot) {
                    // AsyncSnapshot<Your object type>
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text('Please wait its loading...', style: TextStyle(color: state.textTheme.bodyText1!.color),));
                    } else {
                      if (snapshot.hasError)
                        return
                          Center(
                           child: Text('getCollectionImage: ${snapshot.error}'));
                      else
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  WhitePageRoute(enterPage: NftPageView(collectionsItemList, index)),
                                  );
                            },
                            child: Stack(
                              children: [
                                ShaderMask(
                                  shaderCallback: (rect) {
                                    return LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.black, Colors.transparent],
                                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: snapshot.data!.image!.contains('http') ? Image.network(
                                      snapshot.data!.image!,
                                      fit: BoxFit.cover,
                                    ) : Image.file(
                                      File(snapshot.data!.image!),
                                      height: MediaQuery.of(context)
                                          .size
                                          .width /
                                          3,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 30.0,
                                    left: 20.0,
                                    child: Text(collectionsItemList[index].name, style: state.textTheme.headline4)),
                                Positioned(
                                    bottom: 10.0,
                                    left: 20.0,
                                    child: Text('#${collectionsItemList[index].id}',style: state.textTheme.headline4)),
                              ],
                            )
                        );
                    }
                  },
                );
              }
          )),
    );
  }
}
