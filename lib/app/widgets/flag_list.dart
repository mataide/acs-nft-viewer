import 'package:NFT_View/core/models/index.dart';
import 'package:NFT_View/core/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class FlagListWidget extends ConsumerWidget {
  final List<Collections> collectionsList;

  FlagListWidget(this.collectionsList);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final dataState = watch(flagListProvider.notifier);
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
              itemCount: collectionsList.length,
              itemBuilder: (context, index) {
                return FutureBuilder<String>(
                  future: dataState.getCollectionImage(collectionsList[index]),
                  // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    // AsyncSnapshot<Your object type>
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text('Please wait its loading...'));
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
