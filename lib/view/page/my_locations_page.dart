import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lks94tool/constants.dart';
import 'package:lks94tool/controller/converter_actions.dart';
import 'package:lks94tool/controller/location.dart';
import 'package:lks94tool/model/collection.dart';
import 'package:lks94tool/model/location.dart';
import 'package:lks94tool/translations/locale_keys.g.dart';
import 'package:lks94tool/view/widget/drawer.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_localization/easy_localization.dart';

class MyLocationsPage extends StatefulWidget {
  final Collection collection;
  const MyLocationsPage({ Key? key, required this.collection }) : super(key: key);

  @override
  _MyLocationsPageState createState() => _MyLocationsPageState();
}

class _MyLocationsPageState extends State<MyLocationsPage> {
  final String ltuSVG = 'assets/icons/lithuania.svg';
  final String globeSVG = 'assets/icons/globe.svg';

  final LocationController locationController = LocationController();
  final ConverterActionController converterActionController = ConverterActionController();

  bool isSearchBarActive = false;
  void refreshSearch(String input) async{
    widget.collection.setLocations(await locationController.search(input, widget.collection));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(BG_IMAGE), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: isSearchBarActive ? TextField(
            decoration: InputDecoration(hintText: LocaleKeys.location_search.tr()),
            onChanged: (val) {
              setState(()  {
                refreshSearch(val);
              });
            },
          ) : Center(child: Text(widget.collection.name)),
          actions: [
              IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
              IconButton(icon: Icon(Icons.search), onPressed: () {
                setState(() {
                  isSearchBarActive = !isSearchBarActive;
                      print(isSearchBarActive);

                });
              }),
          ],
        


        ),
        
        drawer: DrawerWidget(selectedIndex: 2, isLocationsPage: true, collection: widget.collection),
        body: widget.collection.locations.isNotEmpty ? ListView.builder(
          
          itemCount: widget.collection.locations.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
              child: ListTile(
                tileColor: Colors.amber[400],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
                title: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(widget.collection.locations[index].description, style: TextStyle(fontSize: 25)),
                ),

                subtitle: Column(
        children: [
          Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5),
              child: SvgPicture.asset(ltuSVG, height: 16, width: 16),
            ),
            Flexible(child: Text(widget.collection.locations[index].lksX.toString()+', '+widget.collection.locations[index].lksY.toString(), style: TextStyle(fontSize: 20))),

          ],),
          Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5),
              child: SvgPicture.asset(globeSVG, height: 16, width: 16,),
            ),
            Flexible(child: Text(widget.collection.locations[index].wgsX.toString()+', '+widget.collection.locations[index].wgsY.toString(), style: TextStyle(fontSize: 20))),
          ],),
        ],
                ),
                onTap: () => _openPopup(context, widget.collection.locations[index]),
              ),
            );
          }
        ) : Center(child: Text(LocaleKeys.collection_x_empty.tr(args: [widget.collection.name]), style: TextStyle(fontSize: 25, backgroundColor: Colors.white))),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context).pushNamed('/converter')
        ),
      ),
    );
  }



  _openPopup(context, Location location) {
    ConverterActionController converterActionController = ConverterActionController();
    Alert(
        context: context,
        title: location.description,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: <Widget>[
                Text("LKS-94: "),
                IconButton(onPressed: () => converterActionController.copyToClipboard(
                  context, 
                  location.lksX.toString()+', '+location.lksY.toString()), icon: Icon(Icons.copy),
                ),
                IconButton(onPressed: () => ConverterActionController.showMapOptions(
                  context: context,
                  onMapTap: (map) {
                    map.showMarker(
                      coords: Coords(location.lksX, location.lksY), 
                      title: location.description
                    );
                  }
                ), icon: Icon(Icons.navigation), color: Colors.blue[700])
              ]
            ),
            Row(
              children: <Widget>[
                Text("WGS-94: "),
                IconButton(onPressed: () => converterActionController.copyToClipboard(
                  context, 
                  location.wgsX.toString()+', '+location.wgsY.toString()), icon: Icon(Icons.copy),
                ),
                IconButton(onPressed: () => ConverterActionController.showMapOptions(
                  context: context,
                  onMapTap: (map) {
                    map.showMarker(
                      coords: Coords(location.wgsX, location.wgsY), 
                      title: location.description
                    );
                  }
                ), icon: Icon(Icons.navigation), color: Colors.blue[700])
              ]
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(child: Text(LocaleKeys.location_options.tr(), style: TextStyle(fontSize: 25))),
            ),
            Wrap(
              spacing: 10,
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    _openEditLocationPopup(context, location);
                  }, 
                  icon: Icon(Icons.edit),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: (){
                    if(locationController.delete(location)){
                      Navigator.pop(context);
                      setState(() {
                        widget.collection.locations.removeWhere((element) => element.id == location.id);
                      });
                    }
                  }, 
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            )
          ],
        ),
        buttons: [
          DialogButton(child: Text(LocaleKeys.ok.tr()), onPressed: () => Navigator.pop(context))
        ]).show();
  }
  _openEditLocationPopup(context, Location location) {
    TextEditingController renameTextController = TextEditingController(text: location.description);
    Alert(
        context: context,
        title: LocaleKeys.rename_location_x.tr(args: [location.description]),
        content: Column(
          children: <Widget>[
            TextField(
              controller: renameTextController,
              decoration: InputDecoration(
              labelText: LocaleKeys.updated_location_name.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              )),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              String description = renameTextController.text;
              if (description.isNotEmpty) {
                location.setDescription(description);
                if(locationController.rename(location)){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState(() {
                    
                  });
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
