import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:lks94tool/constants.dart';
import 'package:lks94tool/controller/location.dart';
import 'package:lks94tool/model/collection.dart';
import 'package:lks94tool/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lks94tool/main_common.dart';
class DrawerWidget extends StatefulWidget {
  final int selectedIndex;
  final bool? isLocationsPage;
  final Collection? collection;
  DrawerWidget({Key? key, required this.selectedIndex, this.isLocationsPage, this.collection}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Text('LKS-94 Tool', style: TextStyle(fontSize: 30)),
          ),
                    Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(LocaleKeys.home.tr()),
            selected: widget.selectedIndex == 0,
            onTap: () => widget.selectedIndex != 0 ? goTo('/') : null,
          ),

          ListTile(
            leading: Icon(Icons.replay),
            title: Text(LocaleKeys.converter.tr()),
            selected: widget.selectedIndex == 1,
            onTap: () => widget.selectedIndex != 1 ? goTo('/converter') : null,
          ),
          ListTile(
            leading: Icon(Icons.gps_fixed),
            title: Text(LocaleKeys.my_locations.tr()),
            selected: widget.selectedIndex == 2,
            onTap: () => widget.selectedIndex != 2 ? goTo('/myCollections') : null,
          ),

          widget.isLocationsPage != null ? importExportOptions(widget.collection ?? Collection(name: 'name', createdTime: DateTime.now())) :
          
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text(LocaleKeys.about.tr()),
              selected: widget.selectedIndex == 3,
              onTap: () => goTo('/about'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Divider(
              height: 1,
              thickness: 1,
            ),
          ),
          Center(child: Text(LocaleKeys.version_x.tr(args: [context.read(flavorConfigProvider).state.version]))),
          if (context.read(flavorConfigProvider).state.flavor == 'free')
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  LaunchReview.launch(androidAppId: APP_FULL_VERSION_URL);
                },
                child: Text(LocaleKeys.get_full_version.tr()),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            )
        ],
      ),
    );
  }
  void goTo(String route){
    Navigator.of(context).pushNamed(route);
  }
  Widget importExportOptions(Collection collection){
    bool canImport = context.read(flavorConfigProvider).state.canImport;
    bool canExport = context.read(flavorConfigProvider).state.canExport;
    
    return Column(
      children: [
        Divider(
          height: 1,
          thickness: 1,
        ),
        ListTile(
          leading: Icon(Icons.upload),
          title: Text(LocaleKeys.import_csv.tr()),
          onTap: canImport ? () {
            LocationController.import(context, collection);
            Navigator.pop(context);
            Navigator.pop(context);
          } : null,
          tileColor: canImport ? null : Colors.red[200],
          subtitle: canImport ? null : Text(LocaleKeys.this_function_only_full_version.tr())
        ),             
        ListTile(
          leading: Icon(Icons.download),
          title: Text(LocaleKeys.export_csv.tr()),
          onTap: canExport ? () {
            LocationController.export(context, collection);
            Navigator.pop(context);
          } : null,
          tileColor: canExport ? null : Colors.red[200],
          subtitle: canExport ? null : Text(LocaleKeys.this_function_only_full_version.tr())

        ),
        Divider(
            height: 1,
            thickness: 1,
          ),
      ],
    );
  }
}
