class DataModel {
  int? id, albumId;
  String? title, url;

  DataModel({
    this.albumId,
    this.id,
    this.title,
    this.url,
  });

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return new DataModel(
      albumId: map['albumId'] as int,
      id: map['id'] as int,
      title: map['title'] as String,
      url: map['url'] as String,
    );
  }

  Map<String, dynamic> tomap() {
    return {
      'albumId': this.albumId,
      'id': this.id,
      'title': this.title,
      'url': this.url,
    } as Map<String, dynamic>;
  }
}
