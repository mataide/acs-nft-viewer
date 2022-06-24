import 'package:cached_network_image/cached_network_image.dart';
import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:faktura_nft_viewer/app/home/collections/collections_item.dart';
import 'package:faktura_nft_viewer/app/routes/slide_right_route.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';

class FlagListWidget extends ConsumerWidget {
  final List<Collections> collectionsList;

  FlagListWidget(this.collectionsList);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = ref.watch(flagListProvider(collectionsList).notifier);
    final ThemeData state = ref.watch(themeProvider);

    return Padding(padding: EdgeInsets.all(8.0),child: SingleChildScrollView(
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
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Text(
                    'Please wait its loading...',
                    style: TextStyle(color: state.textTheme.bodyText1!.color),
                  ));
                } else {
                  if (snapshot.hasError) {
                    if (collectionsList[index].image == null ||
                        collectionsList[index].image == "") {
                      return Center(
                          child: Text("Unsupported Image", style: state
                              .textTheme.bodyText1,));
                    }
                    else {
                      return Center(
                          child: Text(
                          'flaglist - getCollectionImage: ${snapshot.error}',style: state
                              .textTheme.bodyText1));
                    }
                  }
                  else
                  return Column(
                      children: [ InkWell(
                    splashColor: state.hoverColor,
                    onTap: () {
                      Navigator.of(context).push(SlideRightRoute(
                          CollectionsItemView(collectionsList[index])));
                    },
                    child: Container(
                      height: 150,
                      width: 200,
                      child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipPath(
                          clipper: CustomTriangleClipper(),
                          child: snapshot.data!.contains('http')
                              ? Container(
                                  height: MediaQuery.of(context).size.width / 3,
                                  child: CachedNetworkImage(
                                    width: MediaQuery.of(context).size.width,
                                    imageUrl: snapshot.data!,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(
                                            color: state.hoverColor),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ))
                              : Image.file(
                                  File(snapshot.data!),
                                  height: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          top: 122,
                          bottom: 0,
                          left: 74,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                            width: 25,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                  width: 10,
                                  height: 20,
                                  child: isValidEthereumAddress(
                                              collectionsList[index]
                                                  .contractAddress) ==
                                          true
                                      ? SvgPicture.asset(
                                          'assets/images/ethereum_logo.svg',
                                          color: Colors.grey,
                                          semanticsLabel: 'Ethereum icon',
                                        )
                                      : Container()),
                            ),
                          ),
                        ),
                          ],
                    ))),
                       // Expanded(child: SizedBox(height: 0.022)),
                           Text(collectionsList[index].tokenName.toUpperCase(), style: state.textTheme.headline4, textAlign: TextAlign.center),
                         Text('#${collectionsList[index].totalSupply}', style: state.textTheme.headline4, textAlign: TextAlign.center),
                         // Expanded(child: SizedBox(height: 0.032)),
                      ]);
                     //
                }
              },
            );
          }),
    ));
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
