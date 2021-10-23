import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';

part 'collections.g.dart';

@entity
@JsonSerializable()
class Collections {
  @PrimaryKey()
  String contractAddress;

  String hash;

  String timeStamp;

  String blockHash;

  String from;

  String to;

  String tokenID;

  String tokenName;

  String tokenSymbol;

  String tokenDecimal;

  String thumbnail;

  String image;

  Collections(this.hash, this.timeStamp, this.blockHash, this.from, this.contractAddress, this.to, this.tokenID, this.tokenName, this.tokenSymbol, this.tokenDecimal, this.thumbnail, this.image);

  factory Collections.fromJson(Map<String, dynamic> json) => _$CollectionsFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionsToJson(this);
}