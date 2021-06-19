import 'package:flutter/material.dart';
import 'package:lks94tool/controller/converter.dart';
import 'package:lks94tool/controller/converter_actions.dart';
import 'package:lks94tool/model/converter.dart';
import 'package:lks94tool/model/location.dart';
import 'package:lks94tool/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ConversionWidget extends StatefulWidget {
  final List<String> conversionType;
  const ConversionWidget({Key? key, required this.conversionType})
      : super(key: key);

  @override
  _ConversionWidgetState createState() => _ConversionWidgetState();
}

class _ConversionWidgetState extends State<ConversionWidget> {
  ConversionController conversionController = ConversionController();
  ConverterActionController converterActionController =
      ConverterActionController();
  dynamic result = [1.0, 1.0];
  String resultString = "";
  bool isSaveButtonEnabled = false;
  bool isMapButtonEnabled = false;

  Converter converter = Converter();

  @override
  Widget build(BuildContext context) {
    resultString = result[0].toString() + ", " + result[1].toString();
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Card(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.amber,
                  padding: const EdgeInsets.all(15),
                  child: Center(
                      child: Text(
                          LocaleKeys.enter_x_coordinates
                              .tr(args: [widget.conversionType[0]]),
                          style: TextStyle(fontSize: 25))),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                  child: Row(
                    children: [
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: TextField(
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                labelText: LocaleKeys.x_coordinates
                                    .tr(args: ['X']),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20)),
                                )),
                            keyboardType: TextInputType.number,
                            controller: widget.conversionType[0]
                                    .contains("LKS")
                                ? conversionController.lksXinputController
                                : conversionController
                                    .wgsXinputController,
                            onChanged: (val) {
                              setState(() {
                                bool canUpdate = (widget.conversionType[0]
                                            .contains("LKS") &&
                                        conversionController.lksXinputController.text !=
                                            "" &&
                                        conversionController
                                                .lksYinputController
                                                .text !=
                                            "" &&
                                        conversionController.isNumeric(
                                            conversionController
                                                .lksXinputController
                                                .text) &&
                                        conversionController.isNumeric(
                                            conversionController
                                                .lksYinputController
                                                .text) &&
                                        val.isNotEmpty) ||
                                    (widget.conversionType[0].contains("WGS") &&
                                        conversionController.wgsXinputController.text != "" &&
                                        conversionController.wgsYinputController.text != "" &&
                                        conversionController.isNumeric(conversionController.wgsXinputController.text) &&
                                        conversionController.isNumeric(conversionController.wgsYinputController.text) &&
                                        val.isNotEmpty);
                                if (canUpdate) {
                                  isSaveButtonEnabled = true;
                                  isMapButtonEnabled = true;
                                  result = widget.conversionType[0]
                                          .contains("LKS")
                                      ? conversionController
                                          .lksXchanged(val)
                                      : conversionController
                                          .wgsXchanged(val);
                                } else {
                                  isSaveButtonEnabled = false;
                                  isMapButtonEnabled = false;
                                }
                              });
                            }),
                      )),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: TextField(
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                labelText: LocaleKeys.x_coordinates
                                    .tr(args: ['Y']),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20)),
                                )),
                            keyboardType: TextInputType.number,
                            controller: widget.conversionType[0]
                                    .contains("LKS")
                                ? conversionController.lksYinputController
                                : conversionController
                                    .wgsYinputController,
                            onChanged: (val) {
                              setState(() {
                                bool canUpdate = (widget.conversionType[0]
                                            .contains("LKS") &&
                                        conversionController.lksXinputController.text !=
                                            "" &&
                                        conversionController
                                                .lksYinputController
                                                .text !=
                                            "" &&
                                        conversionController.isNumeric(
                                            conversionController
                                                .lksXinputController
                                                .text) &&
                                        conversionController.isNumeric(
                                            conversionController
                                                .lksYinputController
                                                .text) &&
                                        val.isNotEmpty) ||
                                    (widget.conversionType[0].contains("WGS") &&
                                        conversionController.wgsXinputController.text != "" &&
                                        conversionController.wgsYinputController.text != "" &&
                                        conversionController.isNumeric(conversionController.wgsXinputController.text) &&
                                        conversionController.isNumeric(conversionController.wgsYinputController.text) &&
                                        val.isNotEmpty);
                                if (canUpdate) {
                                  isSaveButtonEnabled = true;
                                  isMapButtonEnabled = true;
                                  result = widget.conversionType[0]
                                          .contains("LKS")
                                      ? conversionController
                                          .lksYchanged(val)
                                      : conversionController
                                          .wgsYchanged(val);
                                } else {
                                  isSaveButtonEnabled = false;
                                  isMapButtonEnabled = false;
                                }
                              });
                            }),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                          child: Text(
                              LocaleKeys.x_coordinates
                                  .tr(args: [widget.conversionType[1]]),
                              style: TextStyle(fontSize: 25))),
                    ),
                  ),
                  Text(resultString,
                      style: TextStyle(fontSize: 35, color: Colors.red)),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(Icons.star),
                                iconSize: 50,
                                color: Colors.yellow,
                                onPressed: isSaveButtonEnabled
                                    ? () {
                                        double lksX = 1.0;
                                        double lksY = 1.0;
                                        double wgsX = 1.0;
                                        double wgsY = 1.0;
                                        if (widget.conversionType[0]
                                            .contains("LKS")) {
                                          lksX = double.parse(
                                              conversionController
                                                  .lksXinputController
                                                  .text);
                                          lksY = double.parse(
                                              conversionController
                                                  .lksYinputController
                                                  .text);
                                          wgsX = result[0];
                                          wgsY = result[1];
                                        } else if (widget
                                            .conversionType[0]
                                            .contains("WGS")) {
                                          lksX = double.parse(
                                              result[0].toString());
                                          lksY = double.parse(
                                              result[1].toString());
                                          wgsX = double.parse(
                                              conversionController
                                                  .wgsXinputController
                                                  .text);
                                          wgsY = double.parse(
                                              conversionController
                                                  .wgsYinputController
                                                  .text);
                                        }
                                        Location newLocation;
                                        newLocation = Location(
                                            lksX: lksX,
                                            lksY: lksY,
                                            wgsX: wgsX,
                                            wgsY: wgsY,
                                            description: '',
                                            createdTime: DateTime.now());
                                        print(newLocation);
                                        _openPopup(context, newLocation);
                                      }
                                    : null,
                              )),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                icon: Icon(Icons.copy),
                                iconSize: 50,
                                color: Colors.green[900],
                                onPressed: () {
                                  converterActionController
                                      .copyToClipboard(
                                          context, resultString);
                                }),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(Icons.navigation),
                                iconSize: 50,
                                color: Colors.blue[700],
                                onPressed: isMapButtonEnabled
                                    ? () {
                                        ConverterActionController
                                            .showMapOptions(
                                                context: context,
                                                onMapTap: (map) {
                                                  map.showMarker(
                                                      coords: Coords(
                                                          result[0],
                                                          result[1]),
                                                      title:
                                                          resultString);
                                                });
                                      }
                                    : null,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _openPopup(context, Location location) {
    Alert(
        context: context,
        title: LocaleKeys.new_location.tr(),
        content: Column(
          children: <Widget>[
            TextField(
              controller: ConversionController.newLocationNameController,
              decoration: InputDecoration(
                  labelText: LocaleKeys.location_description.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  )),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              String description =
                  ConversionController.newLocationNameController.text;
              if (description.isNotEmpty) {
                location.setDescription(description);
                location.setDescription(
                    ConversionController.newLocationNameController.text);
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/newLocationCooseCollection',
                    arguments: location);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(LocaleKeys.enter_new_location_description.tr())));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.next.tr(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Icon(Icons.arrow_forward)
              ],
            ),
          )
        ]).show();
  }
}
