import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lks94tool/constants.dart';
import 'package:lks94tool/controller/converter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lks94tool/translations/locale_keys.g.dart';
import 'package:lks94tool/view/widget/converter.dart';
import 'package:lks94tool/view/widget/drawer.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({ Key? key }) : super(key: key);

  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  ConversionController conversionController = ConversionController();
  List<String> lksTowgsTypeList = ["LKS-94", "WGS-84"];
  List<String> wgsTolksTypeList = ["WGS-84", "LKS-94"];

  final String ltuSVG = 'assets/icons/lithuania.svg';
  final String globeSVG = 'assets/icons/globe.svg';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(BG_IMAGE), fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(text: "LKS -> WGS", icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(ltuSVG, height: 20, width: 20,),
                      Text("->", style: TextStyle(fontSize: 25)),
                      SvgPicture.asset(globeSVG, height: 20, width: 20,)
                    ])),
                  Tab(text: "WGS -> LKS", icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(globeSVG, height: 20, width: 20,),
                      Text("->", style: TextStyle(fontSize: 25)),
                      SvgPicture.asset(ltuSVG, height: 20, width: 20,)
                    ]))]
              ),
              title: Center(child: Text(LocaleKeys.converter_page_title.tr())),
              
            ),
            drawer: DrawerWidget(selectedIndex: 1),
            body: TabBarView(
              children: [
                ConversionWidget(conversionType: lksTowgsTypeList),
                ConversionWidget(conversionType: wgsTolksTypeList)
              ],
            ),
          ),
        ),
      );
  }


}
