import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';







dialog22({required BuildContext context ,required String error}){
 showDialog(
              context: context,
              builder: (BuildContext context){
                  return Dialog(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  elevation: 20,
  backgroundColor: Colors.white,
  child:Container(
    padding: EdgeInsets.all(20),
    height: MediaQuery.of(context).size.height/3,
    width: MediaQuery.of(context).size.width/2,
    decoration: BoxDecoration(),
    child: Center(
      child: Column(

mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Text('ERROR',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(error,maxLines: 3,style: TextStyle(fontSize: 14),)),
Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
            color: Colors.amber,
        ),
        padding: EdgeInsets.all(5),
    
        child: MaterialButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('BACK')),
      )
        ],
      )
        ],
      ),
    ),
  ) );

              }
            );
}