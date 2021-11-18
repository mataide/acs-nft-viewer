import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WallpaperListWidget extends ConsumerWidget {
  final List<CollectionsItem> collectionsItemList;

  WallpaperListWidget(this.collectionsItemList);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final dataState = watch(wallpaperListProvider.notifier);
    final state = watch(themeProvider);

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
              itemCount: collectionsItemList.length,
              itemBuilder: (context, index) {
                return FutureBuilder<CollectionsItem>(
                  future: dataState.getCollectionItem(collectionsItemList[index]),
                  // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<CollectionsItem> snapshot) {
                    // AsyncSnapshot<Your object type>
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text('Please wait its loading...', style: TextStyle(color: state.textTheme.bodyText1!.color),));
                    } else {
                      if (snapshot.hasError)
                        return Center(
                            child: Text('getCollectionImage: ${snapshot.error}'));
                      else
                        return GestureDetector(
                            onTap: () {
                              print('apertado');
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    snapshot.data!.image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    bottom: 30.0,
                                    left: 20.0,
                                    child: Text(collectionsItemList[index].name)),
                                Positioned(
                                    bottom: 10.0,
                                    left: 20.0,
                                    child: Text('#${collectionsItemList[index].id}')),
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
