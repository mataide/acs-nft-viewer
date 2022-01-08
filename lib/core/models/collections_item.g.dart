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
      description: json['description'] as String?,
      contentType: json['contentType'] as String?,
      thumbnail: json['thumbnail'] as String?,
      image: json['image'] as String?,
      video: json['image'] as String?,
      attributes: json['attributes'] as String?,
    );

Map<String, dynamic> _$CollectionsItemToJson(CollectionsItem instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'id': instance.id,
      'contractAddress': instance.contractAddress,
      'name': instance.name,
      'description': instance.description,
      'contentType': instance.contentType,
      'thumbnail': instance.thumbnail,
      'image': instance.image,
      'video': instance.video,
      'attributes': instance.attributes,
    };
