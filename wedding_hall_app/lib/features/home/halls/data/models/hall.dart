import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'hall.g.dart';

@JsonSerializable(createToJson: false)
class Hall extends Equatable {
  final int id;
  final String name;
  final String location;
  final int capacity;
  final String description;
  final List<PhotoModel> photos;

  const Hall({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.description,
    required this.photos,
  });

  factory Hall.fromJson(Map<String, dynamic> json) => _$HallFromJson(json);

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    capacity,
    description,
    photos,
  ];
}

@JsonSerializable()
class PhotoModel {
  final String url;
  @JsonKey(name: "is_cover")
  final bool isCover;

  PhotoModel({required this.url, required this.isCover});

  factory PhotoModel.fromJson(Map<String, dynamic> json) => _$PhotoModelFromJson(json);

}
