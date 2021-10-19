import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:NFT_View/core/client/APIClient.dart';
import 'package:NFT_View/core/utils/subreddits.dart';
import 'package:NFT_View/ui/views/selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:NFT_View/core/utils/constants.dart';
import 'package:NFT_View/core/models/response.dart';
import 'package:http/http.dart' as http;
import 'package:NFT_View/database_helper/database.dart';

class CarouselWallpaperState extends ChangeNotifier {
  List<Post?> _posts;
  kdataFetchState _fetchState;

  int? _selectedFilter;
  List<String>? _subreddits, _selectedSubreddit;

  CarouselWallpaperState(this._fetchState, this._posts) {
    prepareSharedPrefs();
    prepareFromDb();
  }

  get posts => _posts;
  get state => _fetchState;
  get selectedSubreddit => _selectedSubreddit;
  get selectedFilter => _selectedFilter;
  get subreddits => _subreddits;

  prepareSharedPrefs() async {
    SharedPreferences.getInstance().then((preferences) {
      _subreddits =
          preferences.getStringList('subredditsList') ?? initialSubredditsList;
      _selectedFilter = preferences.getInt('carousel_filter') ?? 0;
      _selectedSubreddit = preferences.getStringList('carousel_subreddit') ??
          [_subreddits![0], _subreddits![1]];



      // fetchWallPapers(EndPoints.getPosts(_selectedSubreddit!.join('+'),
      //     kfilterValues[_selectedFilter!].toLowerCase()));
    });
  }

  fetchWallPapers(String subreddit) async {
    _fetchState = kdataFetchState.IS_LOADING;
    notifyListeners();
    try {
      http.get(Uri.parse(subreddit)).then((res) {
        if (res.statusCode == 200) {
          var decodeRes = jsonDecode(res.body);
          _posts = [];
          Reddit temp = Reddit.fromJson(decodeRes);
          temp.data!.children!.forEach((children) {
            if (children.post!.postHint == 'image') {
              _posts.add(children.post);
            }
          });

          _fetchState = kdataFetchState.IS_LOADED;
          notifyListeners();
        } else {
          _fetchState = kdataFetchState.ERROR_ENCOUNTERED;
          notifyListeners();
        }
      });
    } catch (e) {
      _fetchState = kdataFetchState.ERROR_ENCOUNTERED;
      notifyListeners();
    }
  }

  changeSelected(SelectorCallback selected) {
    _selectedFilter = selected.selectedFilter;
    _selectedSubreddit = selected.selectedSubreddits;
    SharedPreferences.getInstance().then((preferences) {
      preferences.setInt('carousel_filter', _selectedFilter!);
      preferences.setStringList('carousel_subreddit', _selectedSubreddit!);
      prepareSharedPrefs();
    });
  }

  void prepareFromDb() async {
    final database = await $FloorFlutterDatabase.databaseBuilder('app_database.db').build();

    final eth721Dao = database.eth721Dao;
    final result = await eth721Dao.findAll();
    print(result);
  }
}
