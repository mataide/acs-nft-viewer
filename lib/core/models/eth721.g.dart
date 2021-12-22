// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eth721.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Eth721 _$Eth721FromJson(Map<String, dynamic> json) => Eth721(
      json['hash'] as String,
      json['blockNumber'] as String,
      json['timeStamp'] as String,
      json['nonce'] as String,
      json['blockHash'] as String,
      json['from'] as String,
      json['contractAddress'] as String,
      json['to'] as String,
      json['tokenID'] as String,
      json['tokenName'] as String,
      json['tokenSymbol'] as String,
      json['tokenDecimal'] as String,
      json['transactionIndex'] as String,
      json['gas'] as String,
      json['gasPrice'] as String,
      json['gasUsed'] as String,
      json['cumulativeGasUsed'] as String,
      json['input'] as String,
      json['confirmations'] as String,
      json['blockchain'] as String,
    );

Map<String, dynamic> _$Eth721ToJson(Eth721 instance) => <String, dynamic>{
      'hash': instance.hash,
      'blockNumber': instance.blockNumber,
      'timeStamp': instance.timeStamp,
      'nonce': instance.nonce,
      'blockHash': instance.blockHash,
      'from': instance.from,
      'contractAddress': instance.contractAddress,
      'to': instance.to,
      'tokenID': instance.tokenID,
      'tokenName': instance.tokenName,
      'tokenSymbol': instance.tokenSymbol,
      'tokenDecimal': instance.tokenDecimal,
      'transactionIndex': instance.transactionIndex,
      'gas': instance.gas,
      'gasPrice': instance.gasPrice,
      'gasUsed': instance.gasUsed,
      'cumulativeGasUsed': instance.cumulativeGasUsed,
      'input': instance.input,
      'confirmations': instance.confirmations,
      'blockchain': instance.blockchain,
    };
