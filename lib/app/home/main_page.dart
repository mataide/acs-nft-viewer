import 'package:provider/provider.dart';
import 'package:NFT_View/core/utils/constants.dart';
import 'package:NFT_View/core/viewmodels/carousel_wallpaper_state.dart';
import 'package:NFT_View/core/viewmodels/grid_wallpaper_state.dart';
import '../widgets/new.dart';
import '../widgets/popular.dart';
import 'package:flutter/material.dart';

class MainBody extends StatefulWidget {
  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody>
    with AutomaticKeepAliveClientMixin<MainBody> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
        ChangeNotifierProvider(
          create: (_) => GridWallpaperState(kdataFetchState.IS_LOADING, null),
          child: PopularWallpapers(),
        ),
      ],
    );
  }
}
