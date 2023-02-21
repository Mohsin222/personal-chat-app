import 'dart:developer';
import 'dart:io';

import 'package:chat_app/components/btn1.dart';
import 'package:chat_app/components/textfield.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/profile_update_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String fullname='';




//  } 



  @override
  Widget build(BuildContext context) {

     final authProvider =Provider.of<AuthProvider>(context,listen: false);
    fullname=authProvider.logedUser!.fullname.toString();
    
     
    return Scaffold(

      
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text('PROFILE',
      
      style: Theme.of(context).textTheme.headline6,
      ),
 ),
      body: Consumer<ProfileUpdate>(
   
        builder: (context,value,child) {
          value.fullname=fullname;
          return SingleChildScrollView(
            child: Container(
                  height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(authProvider.logedUser!.profilepic.toString()),fit: BoxFit.cover,
                )
              ),
              alignment: Alignment.center,
              child: Container(
             
              height: MediaQuery.of(context).size.height/2,
                child: Stack(
                  alignment: Alignment.center,
             
             
              clipBehavior: Clip.none,
                  children: [
                
                  ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding:  EdgeInsets.all(24),
                  height: MediaQuery.of(context).size.height/1.5,
                  width: MediaQuery.of(context).size.width/1.3,
            
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25),
                    
                    border: Border.all(width: 2,color: Colors.grey)
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height:MediaQuery.of(context).size.height/10
                      ),
                TextFormField(
                  initialValue: fullname,
                  // controller: nameController,
                  decoration: textFieldFunction(context: context,hintTxt: 'Save'),
         onChanged: (text) 
         {
            value.convertText=text;
            print(fullname);
      
         },
           
                  
                  style:  TextStyle(
            color: Theme.of(context).primaryColor, 
            fontSize: 15
                    ),
                ),
             SizedBox(
                        height:MediaQuery.of(context).size.height/10
                      ),
                      Btn1(context: context, text: "Save",press: ()async{
            
      
      
        value.fullname=value.convertText;
           print(fullname);
    var x=   await   value.uploadFile(authProvider: authProvider,context: context);

    log(x.toString());

    if(x==true){
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomeScreen())));
    }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomeScreen())));
          log('Cant Upload');
    }

                      })
          
                    ],
                  ),
                  
                ),
            ),
                     Positioned(
          
                    top: -50,
                     child: GestureDetector(
                      onTap: (){
                        value.pickIamge();
                      },
                       child: CircleAvatar(
                        
                        
                                    
                            radius: MediaQuery.of(context).size.width/6,
                            backgroundImage:  value.imageFile !=null?
                     
                     Image.file(value.imageFile!,
                      fit: BoxFit.cover,).image
                            :NetworkImage(authProvider.logedUser!.profilepic.toString(),
                          
                           
                            ),
                            
                            
                           
                            
                          ),
                     ),
                   ),
                ],),
              )),
          );
        }
      ),
    );
  }
}