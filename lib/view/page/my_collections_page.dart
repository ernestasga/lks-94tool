import 'package:flutter/material.dart';
import 'package:lks94tool/constants.dart';
import 'package:lks94tool/controller/collection.dart';
import 'package:lks94tool/model/collection.dart';
import 'package:lks94tool/translations/locale_keys.g.dart';
import 'package:lks94tool/view/widget/drawer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lks94tool/main_common.dart';

class MyCollectionsPage extends StatefulWidget {
  const MyCollectionsPage({Key? key}) : super(key: key);

  @override
  _MyCollectionsPageState createState() => _MyCollectionsPageState();
}

class _MyCollectionsPageState extends State<MyCollectionsPage> {
  CollectionController collectionController = CollectionController();
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
    return Container(
            decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(BG_IMAGE), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Center(child: Text(LocaleKeys.my_collections.tr())),
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context))
        ),
        endDrawer: DrawerWidget(selectedIndex: 2),
        body: collections.isNotEmpty ? ListView.builder(
          itemCount: collections.length,
          itemBuilder: (context, index) {

            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
              child: ListTile(
                title: Text(collections[index].name, style: TextStyle(fontSize: 30)),
                tileColor: Colors.amber,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(40))),
                trailing: Wrap(
                  spacing: 5,
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        _openEditCollectionPopup(context, collections[index]);
                      }, 
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                    ),
                    IconButton(
                      onPressed: (){
                        collectionController.delete(collections[index]);
                      }, 
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  ],
                ),
                subtitle: Row(children: <Widget>[
                  Icon(Icons.star_border_outlined, color: Colors.green),
                  Text(collections[index].locations.length.toString(), style: TextStyle(fontSize: 25))
                ],),
                onTap: () => Navigator.of(context).pushNamed('/myLocations', arguments: collections[index]),
              ),
            );
          },
          
        ) : Center(
              child: Text(LocaleKeys.no_collections.tr(), style: TextStyle(fontSize: 25, backgroundColor: Colors.white))
            ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: canCreateCollection ? () {
              _openCreateCollectionPopup(context);
            } : () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(LocaleKeys.free_version_collection_x_limit.tr(args: [context.read(flavorConfigProvider).state.collectionCountLimit.toString()]))));
            }),
      ),
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
  _openEditCollectionPopup(context, Collection collection) {
    TextEditingController renameTextController = TextEditingController(text: collection.name);
    Alert(
        context: context,
        title: LocaleKeys.rename_collection_x.tr(args: [collection.name]),
        content: Column(
          children: <Widget>[
            TextField(
              controller: renameTextController,
              decoration: InputDecoration(
              labelText: LocaleKeys.updated_collection_name.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              )),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              String name = renameTextController.text;
              if (name.isNotEmpty) {
                collection.setName(name);
                if(collectionController.rename(collection)){
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
              LocaleKeys.update.tr(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
