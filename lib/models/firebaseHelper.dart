import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHelper{

  static Future<UserModel?> getUserModelbyId(String uid)async{
    UserModel? userModel;

    DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

    if(docSnap.data() !=null){
      userModel = UserModel.fromMap(docSnap.data() as Map<String,dynamic>);


  
    }

    return userModel;
  }

}