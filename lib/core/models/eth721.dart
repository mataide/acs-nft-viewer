import 'package:json_annotation/json_annotation.dart';
//import 'package:floor/floor.dart';

part 'eth721.g.dart';

@JsonSerializable()
class Eth721 {

  String hash;

  String blockNumber;

  String timeStamp;

  String nonce;

  String blockHash;

  String from;

  String contractAddress;

  String to;

  String tokenID;

  String tokenName;

  String tokenSymbol;

  String tokenDecimal;

  String transactionIndex;

  String gas;

  String gasPrice;

  String gasUsed;

  String cumulativeGasUsed;

  String input;

  String confirmations;

  Eth721(this.hash, this.blockNumber, this.timeStamp, this.nonce, this.blockHash, this.from, this.contractAddress, this.to, this.tokenID, this.tokenName, this.tokenSymbol, this.tokenDecimal, this.transactionIndex, this.gas, this.gasPrice, this.gasUsed, this.cumulativeGasUsed, this.input, this.confirmations);

  factory Eth721.fromJson(Map<String, dynamic> json) => _$Eth721FromJson(json);
  Map<String, dynamic> toJson() => _$Eth721ToJson(this);
}