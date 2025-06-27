// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hall _$HallFromJson(Map<String, dynamic> json) => Hall(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  location: json['location'] as String,
  capacity: (json['capacity'] as num).toInt(),
  description: json['description'] as String,
  photos:
      (json['photos'] as List<dynamic>)
          .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

PhotoModel _$PhotoModelFromJson(Map<String, dynamic> json) =>
    PhotoModel(url: json['url'] as String, isCover: json['is_cover'] as bool);

Map<String, dynamic> _$PhotoModelToJson(PhotoModel instance) =>
    <String, dynamic>{'url': instance.url, 'is_cover': instance.isCover};
