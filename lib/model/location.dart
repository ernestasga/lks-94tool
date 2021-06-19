final String tableLocations = 'locations';


class LocationFields {
    static final List<String> values = [
    id, collection, lksX, lksY, wgsX, wgsY, description, time
  ];
  static final String id = '_id';
  static String collection = 'collection';
  static final String lksX = 'lksX';
  static final String lksY = 'lksY';
  static final String wgsX = 'wgsX';
  static final String wgsY = 'wgsY';
  static final String description = 'description';
  static final String time = 'time';
}

class Location{
  final int? id; 
  int? collection;
  setCollection(int newCollection) => collection = newCollection;
  final double lksX;
  final double lksY;
  final double wgsX;
  final double wgsY;
  String description;
  setDescription(String newDescription) => description = newDescription;
  final DateTime createdTime;
  Location({this.id, this.collection, required this.lksX, required this.lksY, required this.wgsX, required this.wgsY, required this.description, required this.createdTime});
  
  Location copy({
    int? id,
    int? collection,
    double? lksX,
    double? lksY,
    double? wgsX,
    double? wgsY,
    String? description,
    DateTime? createdTime,
  }) => 
      Location(
        id: id ?? this.id,
        collection: collection ?? this.collection,
        lksX: lksX ?? this.lksX,
        lksY: lksX ?? this.lksX,
        wgsX: wgsX ?? this.wgsX,
        wgsY: wgsY ?? this.wgsY,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Location fromJson(Map<String, Object?> json) => Location(
    id: json[LocationFields.id] as int?,
    collection: json[LocationFields.collection] as int?,
    lksX: json[LocationFields.lksX] as double, 
    lksY: json[LocationFields.lksY] as double, 
    wgsX: json[LocationFields.wgsX] as double, 
    wgsY: json[LocationFields.wgsY] as double, 
    description: json[LocationFields.description] as String, 
    createdTime: DateTime.parse(json[LocationFields.time] as String),   
  );
  Map<String, Object?> toJson() => {
    LocationFields.id: id,
    LocationFields.collection: collection,
    LocationFields.lksX: lksX,
    LocationFields.lksY: lksY,
    LocationFields.wgsX: wgsX,
    LocationFields.wgsY: wgsY,
    LocationFields.description: description,
    LocationFields.time: createdTime.toIso8601String()
  };
}
