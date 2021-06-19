import 'package:flutter/material.dart';
import 'package:lks94tool/constants.dart';
import 'package:lks94tool/flavor_config.dart';
import 'package:lks94tool/main_common.dart';

void main() {
  final fullConfig = FlavorConfig(
      name: 'LKS-94 Tool Full',
      version: APP_VERSION + ' FULL',
      flavor: 'full',
      canImport: true,
      canExport: true,
      isCollectionCountLimited: false,
      isAdsEnabled: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ));
  mainCommon(fullConfig);
}
