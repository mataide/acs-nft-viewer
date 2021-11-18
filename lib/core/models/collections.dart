import 'package:faktura_nft_viewer/core/models/index.dart';
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

  String? amount;

  String? image;

  int? totalSupply;

  Collections(this.hash, this.timeStamp, this.blockHash, this.from, this.contractAddress, this.to, this.tokenID, this.tokenName, this.tokenSymbol, this.tokenDecimal, this.amount, this.image, this.totalSupply);


  factory Collections.fromEth721(Eth721 eth721, int totalSupply) => _$CollectionsFromEth721(eth721, totalSupply);

  factory Collections.fromJson(Map<String, dynamic> json) => _$CollectionsFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionsToJson(this);
}

Collections _$CollectionsFromEth721(Eth721 eth721, int totalSupply) => Collections(
      eth721.hash,
      eth721.timeStamp,
      eth721.blockHash,
      eth721.from,
      eth721.contractAddress,
      eth721.to,
      eth721.tokenID,
      eth721.tokenName,
      eth721.tokenSymbol,
      eth721.tokenDecimal,
      null,
      null,
      totalSupply
  );