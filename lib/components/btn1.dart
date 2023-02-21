import 'package:flutter/material.dart';

Btn1({required BuildContext context, required String text, required VoidCallback press}){
  return   Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width/2,
              minWidth: MediaQuery.of(context).size.width/2.5
            ),
            child: ElevatedButton( onPressed: press,
            
            style: ButtonStyle.copyWith(
                 backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColorLight),
                 textStyle:MaterialStateProperty.all(TextStyle(
                  color: Theme.of(context).primaryColor,
                  
                 ))
                 ), child: Text(text,
                          style:  TextStyle(
                     fontSize: 25, fontStyle: FontStyle.normal,
                  color: Colors.white),
            
            )
            )
            
          );
}


 // ignore: non_constant_identifier_names
 var ButtonStyle =ElevatedButton.styleFrom(
  
            
              padding: EdgeInsets.all(10),
      

   
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2))),
            );