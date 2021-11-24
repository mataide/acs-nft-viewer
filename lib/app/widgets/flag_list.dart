import 'package:faktura_nft_viewer/app/home/collections/collections_my_collection.dart';
import 'package:faktura_nft_viewer/controllers/widgets/slide_right_route.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class FlagListWidget extends ConsumerWidget {
  final List<Collections> collectionsList;

  FlagListWidget(this.collectionsList);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = ref.watch(flagListProvider.notifier);
    final ThemeData state = ref.watch(themeProvider);

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
              itemCount: collectionsList.length,
              itemBuilder: (context, index) {
                return FutureBuilder<String>(
                  future: dataState.prepareFromDb(collectionsList[index]),
                  // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                              Navigator.of(context).push(SlideRightRoute(MyCollectionView(collectionsList[index])));
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: snapshot.data!.contains('http') ? Image.network(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  ) : Image.file(
                                    File(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    bottom: 30.0,
                                    left: 20.0,
                                    child: Text(collectionsList[index].tokenName)),
                                Positioned(
                                    bottom: 10.0,
                                    left: 20.0,
                                    child: Text('${collectionsList[index].totalSupply}')),
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
