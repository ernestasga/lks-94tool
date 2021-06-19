import 'package:flutter/material.dart';
import 'package:lks94tool/constants.dart';
import 'package:lks94tool/translations/locale_keys.g.dart';
import 'package:lks94tool/view/widget/drawer.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppBar appBar = AppBar(
    title: Center(child: Text(APP_NAME)),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: DrawerWidget(selectedIndex: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/converter'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.replay, size: 50),
                    Text(LocaleKeys.converter.tr(),
                        style: TextStyle(fontSize: 25)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/myCollections'),
                style: ElevatedButton.styleFrom(primary: Colors.amber),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list, size: 50),
                    Text(LocaleKeys.my_locations.tr(),
                        style: TextStyle(fontSize: 25)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
