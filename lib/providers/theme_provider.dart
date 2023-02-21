import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{
    bool? darkThem=false;
  bool get darkTheme => darkThem!;

ThemeProvider(){
  getTheme();
}

    Future<void> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    darkThem = prefs.getBool("theme") ?? false;

    notifyListeners();
  }


    Future<void> changeTheme() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
        darkThem = prefs.getBool("theme")??false ;
              log(darkThem.toString());
    if(darkTheme ==false){
      darkThem=true;
      notifyListeners();
    }else{
      notifyListeners();
      darkThem=false;
    }

    prefs.setBool('theme', darkTheme);
      notifyListeners();
  }

}