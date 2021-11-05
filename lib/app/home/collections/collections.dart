import 'package:NFT_View/core/models/api_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NFT_View/core/utils/constants.dart';
import 'package:NFT_View/app/widgets/selector.dart';
import 'package:NFT_View/core/client/APIClient.dart';
import 'package:NFT_View/core/models/response.dart';
import '../../widgets/wallpaper_list.dart';
import 'collections_widget.dart';

// Providers
import 'package:NFT_View/core/providers/providers.dart';

// Controllers
import 'package:NFT_View/controllers/home/home_collections_controller.dart';

class CollectionsView extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final dataState = watch(homeCollectionsProvider.notifier);
    final themeData = watch(themeProvider);
    final List<DataModel> images;

    return dataState.fetchState == kdataFetchState.IS_LOADING
        ? Container(
            width: double.infinity,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(themeData.colorScheme.secondary),
              ),
            ),
          )
        : dataState.fetchState == kdataFetchState.ERROR_ENCOUNTERED
            ? ErrorOccured(
                onTap: () =>
                    dataState.fetchWallPapers(dataState.selectedSubreddit),
              )
            : ListView(
                padding: const EdgeInsets.all(0.0),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  ListTile(
                    dense: true,
                    trailing: Icon(Icons.edit,
                        color: themeData.textTheme.bodyText1!.color),
                    title: Text(
                        '${kfilterValues[dataState.selectedFilter]} on r/${dataState.selectedSubreddit.join(', ')}',
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: themeData.textTheme.caption),
                    onTap: () async {
                      SelectorCallback? selected =
                          await showModalBottomSheet<SelectorCallback>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return SelectorWidget(
                                  themeData: themeData,
                                  filterSelected: dataState.selectedFilter,
                                  subredditSelected:
                                      dataState.selectedSubreddit,
                                );
                              });

                      if (selected != null) {
                        dataState.changeSelected(selected);
                      }
                    },
                  ),
                  WallpaperList( ),

                ],
              );
  }
}
