import 'package:NFT_View/app/widgets/wallpaper_list.dart';
import 'package:NFT_View/core/models/api_model.dart';
import 'package:NFT_View/core/providers/providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final dataState = watch(apiProvider.notifier);
    final ThemeData state = watch(themeProvider.notifier).state;
    
    return  CustomScrollView(
      slivers: <Widget>[
        //SliverAppBar(expandedHeight: 150.0, backgroundColor: Colors.green),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2
          ),
          delegate: SliverChildBuilderDelegate((BuildContext context, int index){
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                child: WallpaperList(),

            );
          },
            childCount: 2, // Your desired amount of children here
          ),
        ),
      ],
    );
  }
}
