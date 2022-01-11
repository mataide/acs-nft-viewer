import 'package:faktura_nft_viewer/core/models/attributes_item.dart';
import 'package:faktura_nft_viewer/core/models/index.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';

part 'collections_item.g.dart';

@entity
@JsonSerializable()
class CollectionsItem {
  @PrimaryKey()
  String hash;

  String id;

  @ColumnInfo(name: 'contractAddress')
  String contractAddress;

  String name;

  String? description;

  String? contentType;

  String? thumbnail;

  String? image;

  String? video;

  Attributes? attributes;

  CollectionsItem(this.contractAddress, this.hash, this.id, this.name,{this.description, this.contentType, this.thumbnail, this.image, this.video, this.attributes});


  factory CollectionsItem.fromJson(Map<String, dynamic> json) => _$CollectionsItemFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionsItemToJson(this);
}