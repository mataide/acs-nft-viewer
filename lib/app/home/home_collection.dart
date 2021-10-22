import '../widgets/grid_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeCollection extends ConsumerWidget {
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: <Widget>[

        //RETIRANDO UM FILTRO DA HOME
       /* ChangeNotifierProvider(
          create: (_) =>
              CarouselWallpaperState(kdataFetchState.IS_LOADING, null),
          child: NewWallpapers(),
        ),*/
        PopularWallpapers(),
      ],
    );
  }
}
