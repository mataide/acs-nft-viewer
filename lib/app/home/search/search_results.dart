import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:faktura_nft_viewer/core/utils/constants.dart';
import 'package:faktura_nft_viewer/core/models/response.dart';
import 'package:http/http.dart' as http;
import 'package:faktura_nft_viewer/app/home/collections/collections_widget.dart';

class SearchResults extends StatefulWidget {
  final ThemeData? themeData;
  final String? searchTerm;

  SearchResults({Key? key, this.themeData, this.searchTerm}) : super(key: key);
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  kdataFetchState _fetchState = kdataFetchState.IS_LOADING;

  @override
  void initState() {
    super.initState();
    //fetchWallPapers(EndPoints.getSearch(widget.searchTerm!));
  }

  void fetchWallPapers(String subreddit) async {
    setState(() {
      _fetchState = kdataFetchState.IS_LOADING;
    });
    http.get(Uri.parse(subreddit)).then((res) {
      if (res.statusCode == 200) {
        var decodeRes = jsonDecode(res.body);
       // posts = [];
        Reddit temp = Reddit.fromJson(decodeRes);
        temp.data!.children!.forEach((children) {
          if (children.post!.postHint == 'image') {
          //  posts!.add(children.post);
          }
        });
        if (mounted) {
          setState(() {
            _fetchState = kdataFetchState.IS_LOADED;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _fetchState = kdataFetchState.IS_LOADED;
          });
        }
      }
    }).catchError((onError) {
      if (mounted) {
        setState(() {
          _fetchState = kdataFetchState.ERROR_ENCOUNTERED;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return mainList();
  }

  Widget mainList() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: widget.themeData!.primaryColor,
      child: Center(
        child: _fetchState == kdataFetchState.IS_LOADING
            ? CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(widget.themeData!.accentColor),
              )
            : _fetchState == kdataFetchState.ERROR_ENCOUNTERED
                ? ErrorOccured(
                    //onTap: () =>
                        //fetchWallPapers(EndPoints.getSearch(widget.searchTerm!)),
                  )
            : WallpaperList( themeData: widget.themeData),
      )
    );
  }
}

WallpaperList({posts, ThemeData? themeData}) {
}
