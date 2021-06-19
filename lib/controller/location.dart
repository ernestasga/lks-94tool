import 'dart:io';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lks94tool/database/database.dart';
import 'package:lks94tool/model/collection.dart';
import 'package:lks94tool/model/location.dart';
import 'package:lks94tool/model/spreadsheet.dart';
import 'package:lks94tool/translations/locale_keys.g.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';

class LocationController {
  TextEditingController newLocDescrController = TextEditingController();



  bool create(Location location) {
    LocationsDatabase.instance.createLocation(location);
    return true;
  }
  bool rename(Location location){
    LocationsDatabase.instance.updateLocation(location);
    return true;
  }
  bool delete(Location location){
    int id = location.id ?? 0;
    LocationsDatabase.instance.deleteLocation(id);
    return true;
  }
  static void export(BuildContext context, Collection collection) async{
    String result = Spreadsheet.locationsToCSV(collection.locations);
    String name = collection.name+'.csv';
    String message = '';
    try {
      if (result.length > 50) {
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            await Permission.storage.request();
          }
          Directory tempDir = await DownloadsPathProvider.downloadsDirectory;
          String tempPath = tempDir.path;
          var filePath = tempPath + '/$name';
          File(filePath).writeAsString(result); 
          message = LocaleKeys.saved_to.tr(args: [filePath]);
      }else{
        message = LocaleKeys.nothing_to_save.tr();
      }
    } catch (e) {
      message = LocaleKeys.error.tr();
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)));
  }

  static void import(BuildContext context, Collection collection) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv']
    );
    if (result != null) {
      File file = File(result.files.single.path);
      List<Location> locations = await Spreadsheet.cvsToLocations(file);
      for (var i = 0; i < locations.length; i++) {
        locations[i].setCollection(collection.id ?? 0);
        LocationsDatabase.instance.createLocation(locations[i]);
      }
    } 
  }

  Future<List<Location>> search(String input, Collection collection) async{
    List<Location> locations = await LocationsDatabase.instance.getAlCollectionLocations(collection.id ?? 0);
    List<Location> list = [];
    if (input.length > 1) {
      for (var i = 0; i < locations.length; i++) {
        if(locations[i].description.toLowerCase().contains(input.toLowerCase())){
          list.add(locations[i]);
        }
      }
    }
    else{
      return locations;
    }
    return list;    
  }

}
