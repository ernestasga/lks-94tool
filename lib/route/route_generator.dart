import 'package:flutter/material.dart';
import 'package:lks94tool/model/collection.dart';
import 'package:lks94tool/model/location.dart';
import 'package:lks94tool/route/error.dart';
import 'package:lks94tool/view/page/about_page.dart';
import 'package:lks94tool/view/page/converter_page.dart';
import 'package:lks94tool/view/page/home_page.dart';
import 'package:lks94tool/view/page/my_collections_page.dart';
import 'package:lks94tool/view/page/my_locations_page.dart';
import 'package:lks94tool/view/page/new_location_choose_collection_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/converter':
        return MaterialPageRoute(builder: (_) => ConverterPage());
      case '/myCollections':
        return MaterialPageRoute(builder: (_) => MyCollectionsPage());
      case '/myLocations':
        if(args is Collection){
          return MaterialPageRoute(builder: (_) => MyLocationsPage(collection: args));
        }
        return MaterialPageRoute(builder: (_) => Error404Screen());
      case '/newLocationCooseCollection':
        if(args is Location){
          return MaterialPageRoute(builder: (_) => NewLocationChooseCollectionPage(newLocation: args));
        }
        return MaterialPageRoute(builder: (_) => Error404Screen());
      case '/about':
        return MaterialPageRoute(builder: (_) => AboutPage());
      default:
        return MaterialPageRoute(builder: (_) => Error404Screen());
    }
  }
}
