class DataModel {
  int? id, albumId;
  String title, url;

  DataModel({
    this.albumId,
    this.id,
    required this.title,
    required this.url,
  });

  //factory DataModel.fromMap(Map<String, dynamic> map) {
  //return new DataModel(
  //     albumId: map['albumId'] as int,
  // id: map['id'] as int,
  // title: map['title'] as String,
  //  url: map['url'] as String,
  //);
  // }
  static DataModel fromJson(json) => DataModel(
        id: json['id'],
        title: json['title'],
        url: json['url'],
      );

  Map<String, dynamic> tomap() {
    return {
      'albumId': this.albumId,
      'id': this.id,
      'title': this.title,
      'url': this.url,
    } as Map<String, dynamic>;
  }
}
