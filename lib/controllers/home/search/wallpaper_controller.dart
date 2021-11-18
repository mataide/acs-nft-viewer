import 'package:faktura_nft_viewer/core/models/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WallPaperState {
  final List<Post?> posts;
  final int index;
  final String heroId;
  final Post? currentPost;

  const WallPaperState({this.posts = const [], this.index = 0, this.heroId = "", this.currentPost});
}

class WallPaperController extends StateNotifier<WallPaperState> {
  WallPaperController([WallPaperState? state]) : super(WallPaperState());

  List<Post?> get posts => state.posts;
  int get index => state.index;
  String get heroId => state.heroId;
  Post? get currentPost => state.currentPost;

  void setCurrentPost(index) {
    state = WallPaperState(currentPost: state.posts[index]);
  }

  void setInitialData(posts, index, heroId, currentPost) {
    state = WallPaperState(currentPost: currentPost, posts: posts, heroId: heroId, index: index);
  }

}