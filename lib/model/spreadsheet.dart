import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:lks94tool/model/location.dart';

class Spreadsheet {
  static String locationsToCSV(List<Location> locations){
    List<List<dynamic>> rows = [];
    List<String> header = [];
    header.add('LKS-94 X');
    header.add('LKS-94 Y');
    header.add('WGS-84 X');
    header.add('WGS-84 Y');
    header.add('Aprasymas');
    rows.add(header);
    for(int i = 0; i<locations.length; i++){
      List<dynamic> row = [];
      row.add(locations[i].lksX);
      row.add(locations[i].lksY);
      row.add(locations[i].wgsX);
      row.add(locations[i].wgsY);
      row.add(locations[i].description);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    return csv;
  }

  static Future<List<Location>> cvsToLocations(File csv) async {
    final input = csv.openRead();
    final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    List<Location> locations = [];
    for (var i = 1; i < fields.length; i++) {
      try {
        Location location = new Location(
          lksX: double.parse(fields[i][0].toString()), 
          lksY: double.parse(fields[i][1].toString()),
          wgsX: double.parse(fields[i][2].toString()),
          wgsY: double.parse(fields[i][3].toString()),
          description: fields[i][4].toString(), 
          createdTime: DateTime.now()
        );
        locations.add(location);
      } on Exception catch (e) {
          print(e);
      }
    }
    return locations;
  }
}
