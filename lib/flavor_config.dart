import 'package:flutter/material.dart';

class FlavorConfig {
  String name;
  String version;
  String flavor;
  bool canImport;
  bool canExport;

  bool isCollectionCountLimited;
  int? collectionCountLimit;

  bool isAdsEnabled;

  ThemeData theme;

  FlavorConfig({
    required this.name,
    required this.version, 
    required this.flavor,
    required this.canImport, 
    required this.canExport, 
    required this.isCollectionCountLimited,
    this.collectionCountLimit,
    required this.isAdsEnabled,
    required this.theme,
    });
}
