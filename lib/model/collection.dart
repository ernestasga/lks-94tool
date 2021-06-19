import 'package:lks94tool/model/location.dart';

final String tableCollections = 'collections';

class CollectionFields {
  static final List<String> values = [
    id, name, time
  ];

  static final String id = '_id';
  static String name = 'name';
  static final String time = 'time';

}

class Collection{
  final int? id;
  String name;
  setName(String newName) => name = newName;
  final DateTime createdTime;

  List<Location> locations = [];
  setLocations(List<Location> newLocations) => locations = newLocations;

  Collection({this.id, required this.name, required this.createdTime});

  Collection copy({
    int? id,
    String? name,
    DateTime? createdTime,
  }) => 
      Collection(
        id: id ?? this.id,
        name: name ?? this.name,
        createdTime: createdTime ?? this.createdTime,
      );

  static Collection fromJson(Map<String, Object?> json) => Collection(
    id: json[CollectionFields.id] as int?,
    name: json[CollectionFields.name] as String, 
    createdTime: DateTime.parse(json[CollectionFields.time] as String),   
  );
  Map<String, Object?> toJson() => {
    CollectionFields.id: id,
    CollectionFields.name: name,
    CollectionFields.time: createdTime.toIso8601String()
  };
}
