import 'package:flutter/material.dart';
import 'package:lks94tool/model/converter.dart';

class ConversionController {
  var result = [];
  double inputLksX = 1.0;
  double inputLksY = 1.0;

  double inputWgsX = 1.0;
  double inputWgsY = 1.0;

  Converter converter = Converter();

  final TextEditingController lksXinputController = TextEditingController();
  final TextEditingController lksYinputController = TextEditingController();
  
  final TextEditingController wgsXinputController = TextEditingController();
  final TextEditingController wgsYinputController = TextEditingController();

  static TextEditingController newLocationNameController = TextEditingController();


  lksXchanged(var val){
    inputLksX = double.parse(val);
    result = converter.lks94TOwgs84(inputLksX, double.parse(lksYinputController.text.toString()));
    return result;
  }
  lksYchanged(var val){
    inputLksY = double.parse(val);
    result = converter.lks94TOwgs84(double.parse(lksXinputController.text.toString()), inputLksY);
    return result;
  }

  wgsXchanged(var val){
    inputWgsX = double.parse(val);
    result = converter.wgs84TOlks94(inputWgsX, double.parse(wgsYinputController.text.toString()));
    return result;
  }
  wgsYchanged(var val){
    inputWgsY = double.parse(val);
    result = converter.wgs84TOlks94(double.parse(wgsXinputController.text.toString()), inputWgsY);
    return result;
  }

  bool isNumeric(String s) {
    if (s == '') {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
