// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Collections _$CollectionsFromJson(Map<String, dynamic> json) => Collections(
      json['hash'] as String,
      json['timeStamp'] as String,
      json['blockHash'] as String,
      json['from'] as String,
      json['contractAddress'] as String,
      json['to'] as String,
      json['tokenID'] as String,
      json['tokenName'] as String,
      json['tokenSymbol'] as String,
      json['tokenDecimal'] as String,
      json['blockchain'] as String,
      json['isNotSupported'] as bool,
      json['externalUrl'] as String?,
      json['description'] as String?,
      json['amount'] as String?,
      json['image'] as String?,
      json['totalSupply'] as int?,
    );

Map<String, dynamic> _$CollectionsToJson(Collections instance) =>
    <String, dynamic>{
      'contractAddress': instance.contractAddress,
      'hash': instance.hash,
      'timeStamp': instance.timeStamp,
      'blockHash': instance.blockHash,
      'from': instance.from,
      'to': instance.to,
      'tokenID': instance.tokenID,
      'tokenName': instance.tokenName,
      'tokenSymbol': instance.tokenSymbol,
      'tokenDecimal': instance.tokenDecimal,
      'blockchain': instance.blockchain,
      'isNotSupported': instance.isNotSupported,
      'externalUrl': instance.externalUrl,
      'description': instance.description,
      'amount': instance.amount,
      'image': instance.image,
      'totalSupply': instance.totalSupply,
    };
