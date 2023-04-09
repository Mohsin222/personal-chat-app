

import 'package:flutter/material.dart';

InputDecoration textFieldDecoration =   InputDecoration(


                hintText: 'Enter your email',
                
               
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(32.0)),
                // ),
           
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                         color: Colors.grey, 
                         width: 2)),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              );





//to reduce lines of code
              InputDecoration textFieldFunction({required BuildContext context,required String hintTxt}){
                return textFieldDecoration.copyWith(
                hintText: hintTxt,
             hintStyle: TextStyle(
                  color: Theme.of(context).primaryColor
                ),
               
                focusedBorder: UnderlineInputBorder(
borderSide: BorderSide(color: Theme.of(context).primaryColor)
                ),
                    enabledBorder: UnderlineInputBorder(
borderSide: BorderSide(color: Theme.of(context).primaryColorLight)
                ),
              );
              }