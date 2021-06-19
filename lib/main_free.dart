import 'package:flutter/material.dart';
import 'package:lks94tool/constants.dart';
import 'package:lks94tool/flavor_config.dart';
import 'package:lks94tool/main_common.dart';

void main(){
  final freeConfig = FlavorConfig(
    name: 'LKS-94 Tool',
    version: APP_VERSION+' FREE', 
    flavor: 'free',
    canImport: false, 
    canExport: false, 
    isCollectionCountLimited: true, 
    collectionCountLimit: 1,
    isAdsEnabled: true,
    theme: ThemeData(
        primarySwatch: Colors.red,
    ), 
  
  );
  mainCommon(freeConfig);
}
