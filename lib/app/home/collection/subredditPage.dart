import 'dart:convert';
import 'package:NFT_View/core/models/eth721.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../core/models/response.dart';
import '../../../core/client/APIClient.dart';
import '../search/search_results/wallpaper_list.dart';

class SubredditPage extends StatefulWidget {
  final ThemeData? themeData;
  final String? subreddit;
  SubredditPage({Key? key, this.themeData, this.subreddit}) : super(key: key);
  @override
  _SubredditPageState createState() => _SubredditPageState();
}

class _SubredditPageState extends State<SubredditPage> {
  String? filterValue = kfilterValues[0];

  bool isLoading = true;
  List<Post?>? posts;

  @override
  Future<void> initState() async {
    super.initState();
    List<Eth721> eth721 = await APIService.instance.getERC721("");
    //fetchWallPapers(EndPoints.getPosts(widget.subreddit, filterValue!));
  }

  void fetchWallPapers(url) async {
    setState(() {
      isLoading = true;
    });
    http.get(Uri.parse(url)).then((res) {
      if (res.statusCode == 200) {
        var decodeRes = jsonDecode(res.body);
        posts = [];
        posts!.clear();
        Reddit temp = Reddit.fromJson(decodeRes);
        temp.data!.children!.forEach((children) {
          if (children.post!.postHint == 'image') {
            posts!.add(children.post);
          }
        });
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.themeData!.primaryColor,
        title: Text('r/${widget.subreddit}',
            style: widget.themeData!.textTheme.bodyText2),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: widget.themeData!.textTheme.bodyText1!.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Theme(
              data: widget.themeData!
                  .copyWith(canvasColor: widget.themeData!.primaryColor),
              child: DropdownButton<String>(
                underline: Container(),
                style: widget.themeData!.textTheme.bodyText1,
                value: filterValue,
                items: kfilterValues.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: widget.themeData!.textTheme.bodyText1,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (!isLoading) {
                    setState(() {
                      filterValue = value;
                    });

                    //fetchWallPapers(widget.subreddit, filterValue!);
                  }
                },
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: widget.themeData!.primaryColor,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(widget.themeData!.accentColor),
                ),
              )
            : WallpaperList(posts: posts, themeData: widget.themeData),
      ),
    );
  }
}