import 'package:cached_network_image/cached_network_image.dart';
import 'package:faktura_nft_viewer/app/home/collections/collections_my_collection.dart';
import 'package:faktura_nft_viewer/app/routes/slide_right_route.dart';
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
    final data = ref.watch(loginProvider);

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
                              if (data.listAddress.length > 0) {
                                Navigator.of(context).push(SlideRightRoute(
                                    MyCollectionView(collectionsList[index])));
                              }
                              },
                            child: Stack(
                              children: [
                                ClipPath(
                                  clipper: CustomTriangleClipper(),
                                  child: snapshot.data!.contains('http') ? CachedNetworkImage(
                                    imageUrl: snapshot.data!,
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(

                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            image: imageProvider, fit: BoxFit.fitHeight),
                                      ),
                                    ),
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ) : Image.file(
                                    File(snapshot.data!),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(gradient: new LinearGradient(colors: <Color>[
                                      const Color(0xCC000000),
                                      Color(0x66000000),
                                      Color(0x00000000),
                                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
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

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height/1.2);
    path.lineTo(size.width/2, size.height);
    path.lineTo(size.width, size.height/1.2);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
