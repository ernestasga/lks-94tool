import 'package:flutter/material.dart';
import 'package:lks94tool/controller/collection.dart';
import 'package:lks94tool/controller/location.dart';
import 'package:lks94tool/main_common.dart';
import 'package:lks94tool/model/collection.dart';
import 'package:lks94tool/model/location.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lks94tool/translations/locale_keys.g.dart';
import 'package:lks94tool/view/widget/drawer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class NewLocationChooseCollectionPage extends StatefulWidget {
  final Location newLocation;
  const NewLocationChooseCollectionPage({ Key? key, required this.newLocation }) : super(key: key);

  @override
  _NewLocationChooseCollectionPageState createState() => _NewLocationChooseCollectionPageState();
}

class _NewLocationChooseCollectionPageState extends State<NewLocationChooseCollectionPage> {
  CollectionController collectionController = CollectionController();
  LocationController locationController = LocationController();
  late List<Collection> collections = [];
  bool isLoading = true;
  bool canCreateCollection = true;

  @override
  void initState(){
    super.initState();
    getCollections();
  }
  Future getCollections() async{
    List<Collection> result = await collectionController.getCollections();
    this.collections = result;
    if(mounted){
      setState(() {
        isLoading = false;
        int? collectionCountLimit = context.read(flavorConfigProvider).state.collectionCountLimit;
        if (collectionCountLimit != null && result.length >= collectionCountLimit) {
          canCreateCollection = false;
        }else if(collectionCountLimit == null){
          canCreateCollection = true;
        }      
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    getCollections();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(LocaleKeys.choose_collection.tr())),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))
      ),
      endDrawer: DrawerWidget(selectedIndex: -1),
      body: collections.isNotEmpty ? ListView.builder(
        itemCount: collections.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: ListTile(
              title: Text(collections[index].name, style: TextStyle(fontSize: 30)),
              subtitle: Row(children: <Widget>[
                Icon(Icons.star_border_outlined),
                Text(collections[index].locations.length.toString(), style: TextStyle(fontSize: 25))
              ],),
              onTap: () {
                int collectionId = collections[index].id ?? 0;
                widget.newLocation.setCollection(collectionId);
                if(locationController.create(widget.newLocation)){
                  Navigator.of(context).popAndPushNamed('/myCollections');
                }
              },
            ),
          );
        },
        
      ) : Center(
            child: Text(LocaleKeys.no_collections.tr(), style: TextStyle(fontSize: 25))
          ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: canCreateCollection ? () {
            _openCreateCollectionPopup(context);
          } : () {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(LocaleKeys.free_version_collection_x_limit.tr(args: [context.read(flavorConfigProvider).state.collectionCountLimit.toString()]))));
          }),
    );
  }
  _openCreateCollectionPopup(context) {
    Alert(
        context: context,
        title: LocaleKeys.new_collection.tr(),
        content: Column(
          children: <Widget>[
            TextField(
              controller: collectionController.newCollectionNameController,
              decoration: InputDecoration(
                  labelText: LocaleKeys.collection_name.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              String name =
                  collectionController.newCollectionNameController.text;
              if (name.isNotEmpty) {
                if(collectionController.create(name)){
                  Navigator.pop(context);
                }else{
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(LocaleKeys.error.tr())));                  
                }
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(LocaleKeys.enter_new_collection_name.tr())));
              }
            },
            child: Text(
              LocaleKeys.create.tr(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
