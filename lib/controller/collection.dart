import 'package:flutter/cupertino.dart';
import 'package:lks94tool/database/database.dart';
import 'package:lks94tool/model/collection.dart';
import 'package:lks94tool/model/location.dart';

class CollectionController{
  final TextEditingController newCollectionNameController = TextEditingController();

  bool create(String name){
    Collection newCollection = Collection(name: name, createdTime: DateTime.now());
    LocationsDatabase.instance.createCollection(newCollection);
    
    return true;
  }
  Future<List<Collection>> getCollections() async {
    List<Collection> collections = await LocationsDatabase.instance.getAllCollections(); 
    for(var i = 0; i<collections.length; i++){
      int colId = collections[i].id ?? 0;
      List<Location> locations = await LocationsDatabase.instance.getAlCollectionLocations(colId);
      collections[i].locations = locations;
    }
    return collections;
  }
  bool delete(Collection collection){
    int id = collection.id ?? 0;
    LocationsDatabase.instance.deleteCollection(id);
    for(var i = 0; i<collection.locations.length;i++){
      int locId = collection.locations[i].id ?? 0;
      LocationsDatabase.instance.deleteLocation(locId);
    }
    return true;
  }
  bool rename(Collection collection){
    LocationsDatabase.instance.updateCollection(collection);
    return true;
  }

}
