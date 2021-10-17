import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:NFT_View/core/client/APIClient.dart';
import 'package:NFT_View/core/utils/subreddits.dart';
import 'package:NFT_View/ui/views/selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/response.dart';
import 'package:http/http.dart' as http;

class GridWallpaperState extends ChangeNotifier {
  List<Post?>? _posts;
  kdataFetchState _fetchState;

  int? _selectedFilter;
  List<String>? _subreddits, _selectedSubreddit;

  GridWallpaperState(this._fetchState, this._posts) {
    prepareSharedPrefs();
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
      _selectedFilter = preferences.getInt('list_filter') ?? 0;
      _selectedSubreddit = preferences.getStringList('list_subreddit') ??
          [_subreddits![4], _subreddits![5]];

      fetchWallPapers(EndPoints.getPosts(_selectedSubreddit!.join('+'),
          kfilterValues[_selectedFilter!].toLowerCase()));
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
              _posts!.add(children.post);
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
      preferences.setInt('list_filter', _selectedFilter!);
      preferences.setStringList('list_subreddit', _selectedSubreddit!);
      prepareSharedPrefs();
    });
  }
}
