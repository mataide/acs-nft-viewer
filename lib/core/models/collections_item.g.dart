// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collections_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionsItem _$CollectionsItemFromJson(Map<String, dynamic> json) =>
    CollectionsItem(
      json['contractAddress'] as String,
      json['hash'] as String,
      json['id'] as String,
      json['name'] as String,
      json['description'] as String,
      json['contentType'] as String,
      json['thumbnail'] as String?,
      json['image'] as String,
    );

Map<String, dynamic> _$CollectionsItemToJson(CollectionsItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contractAddress': instance.contractAddress,
      'hash': instance.hash,
      'name': instance.name,
      'description': instance.description,
      'contentType': instance.contentType,
      'thumbnail': instance.thumbnail,
      'image': instance.image,
    };
