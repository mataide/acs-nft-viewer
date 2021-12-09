import 'package:faktura_nft_viewer/app/home/collections/my_collection_item/nft_page.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:faktura_nft_viewer/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';

//Create a transition that fades in the new view, while fading out a white background
class WhitePageRoute extends PageRouteBuilder {
  final Widget enterPage;


  WhitePageRoute({required this.enterPage,})
      : super(
      transitionDuration: Duration(milliseconds: 70),
      pageBuilder: (context, animation, secondaryAnimation, ) => enterPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child,) {
        var fadeIn =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Interval(.7, 1), parent: animation));
        var fadeOut =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Interval(0, .2), parent: animation));
        return Stack(children: <Widget>[
          FadeTransition(opacity: fadeOut, child: Container()),
          FadeTransition(opacity: fadeIn, child: child)
        ]);
      });
}
