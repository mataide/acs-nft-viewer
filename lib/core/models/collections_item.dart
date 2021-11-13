import 'package:NFT_View/core/models/index.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';

part 'collections_item.g.dart';

@Entity(
  tableName: 'CollectionsItem',
  foreignKeys: [
    ForeignKey(
      childColumns: ['contractAddress'],
      parentColumns: ['id'],
      entity: Collections,
    )
  ],
)
@JsonSerializable()
class CollectionsItem {
  @PrimaryKey()
  String id;

  @ColumnInfo(name: 'contractAddress')
  String contractAddress;

  String hash;

  String name;

  String description;

  String contentType;

  String? thumbnail;

  String image;

  CollectionsItem(this.contractAddress, this.hash, this.id, this.name, this.description, this.contentType, this.thumbnail, this.image);


  factory CollectionsItem.fromJson(Map<String, dynamic> json) => _$CollectionsItemFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionsItemToJson(this);
}