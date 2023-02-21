import 'package:flutter/cupertino.dart';

class FunctionsProvider extends ChangeNotifier{
String initalVal='aa';
var a=['aa','bb','cc'];


changeVal(value){

initalVal=value;
notifyListeners();
}
}