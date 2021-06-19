import 'package:lks94tool/model/collection.dart';
import 'package:lks94tool/model/location.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocationsDatabase {
  static final LocationsDatabase instance = LocationsDatabase._init();

  static Database? _database;

  LocationsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('locations.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final intType = 'INTEGER NOT NULL';
    final doubleType = 'DOUBLE NOT NULL';

    await db.execute('''
      CREATE TABLE $tableCollections (
        ${CollectionFields.id} $idType,
        ${CollectionFields.name} $textType,
        ${CollectionFields.time}
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableLocations (
        ${LocationFields.id} $idType,
        ${LocationFields.collection} $intType,
        ${LocationFields.lksX} $doubleType,
        ${LocationFields.lksY} $doubleType,
        ${LocationFields.wgsX} $doubleType,
        ${LocationFields.wgsY} $doubleType,
        ${LocationFields.description} $textType,
        ${LocationFields.time}
      )
    ''');
  }

  Future<Collection> createCollection(Collection collection) async {
    final db = await instance.database;
    final id = await db.insert(tableCollections, collection.toJson());
    return collection.copy(id: id);
  }
  Future<Location> createLocation(Location location) async {
    final db = await instance.database;
    final id = await db.insert(tableLocations, location.toJson());
    return location.copy(id: id);
  }
  Future<Collection> getCollection(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCollections,
      columns: CollectionFields.values,
      where: '${CollectionFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Collection.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Collection>> getAllCollections() async {
    final db = await instance.database;
    final result = await db.query(tableCollections);

    return result.map((json) => Collection.fromJson(json)).toList();
  }

  Future<List<Location>> getAlCollectionLocations(int colection) async {
    final db = await instance.database;
    final result = await db.query(tableLocations,
        where: '${LocationFields.collection} = ?',
        whereArgs: [colection],
    );
    return result.map((json) => Location.fromJson(json)).toList();
  }

  Future<int> updateCollection(Collection collection) async {
    final db = await instance.database;
    return db.update(
      tableCollections,
      collection.toJson(),
      where: '${CollectionFields.id} = ?',
      whereArgs: [collection.id],
    );
  }

  Future<int> deleteLocation(int id) async {
    final db = await instance.database;
    return db.delete(
        tableLocations, 
        where: '${LocationFields.id} = ?', 
        whereArgs: [id]);
  }
  Future<int> deleteCollection(int id) async {
    final db = await instance.database;
    return db.delete(
      tableCollections,
      where: '${CollectionFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateLocation(Location location) async {
    final db = await instance.database;
    return db.update(
        tableLocations, 
        location.toJson(),
        where: '${LocationFields.id} = ?', 
        whereArgs: [location.id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
