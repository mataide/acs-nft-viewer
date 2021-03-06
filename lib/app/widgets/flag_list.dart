import 'package:cached_network_image/cached_network_image.dart';
import 'package:faktura_nft_viewer/app/home/collections/collections_item.dart';
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 0.9,
              ),
              itemCount: collectionsList.length,
              itemBuilder: (context, index) {
                return FutureBuilder<String>(
                  future: dataState.prepareFromDb(collectionsList[index]),
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
                        print(collectionsList[index].image);
                        print(collectionsList[index].description);

                        return InkWell(
                            splashColor: state.accentColor,
                            onTap: () {
                              Navigator.of(context).push(SlideRightRoute(
                                  CollectionsItemView(collectionsList[index])));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipPath(
                                  clipper: CustomTriangleClipper(),
                                  child: snapshot.data!.contains('http')
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: CachedNetworkImage(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            imageUrl: snapshot.data!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(color: state.accentColor),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ))
                                      : Image.file(
                                          File(snapshot.data!),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Expanded(child: SizedBox(height: 0.032)),
                                Expanded(child: Text(collectionsList[index].tokenName.toUpperCase(), style: state.textTheme.headline4, textAlign: TextAlign.center)),
                                Expanded(child: Text('#${collectionsList[index].totalSupply}', style: state.textTheme.headline4, textAlign: TextAlign.center)),
                                Expanded(child: SizedBox(height: 0.032)),
                              ],
                            ));
                    }
                  },
                );
              })),
    );
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height / 1.2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height / 1.2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.red;
    Path path = Path();
//    uncomment this and will get the border for all lines
    path.lineTo(0, size.height / 1.2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height / 1.2);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}