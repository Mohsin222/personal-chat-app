import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/components/dialog.dart';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthProvider with ChangeNotifier {

  AuthProvider(){
      User? currentUser = FirebaseAuth.instance.currentUser;
        if(currentUser != null) {
    // Logged In

    
       fetchUserDetails(currentUser.uid.toString());
    }
  
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? logedUser;
  bool loading = false;
  Future login(String email, String password, context) async {
    try {
      loading = true;
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.toString(), password: password.toString());
      User? user = userCredential.user;

      logedUser = UserModel(
        uid: user!.uid,
        email: user.email,
      );

      if (logedUser != null) {
       
        fetchUserDetails(logedUser!.uid.toString());
        

      
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.id, (Route<dynamic> route) => false);
             loading = false;
      }

      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      loading = false;
      log(e.toString());
      notifyListeners();
      return dialog22(context: context, error: e.toString());
    }
  }

  fetchUserDetails(String uid) async {
    var data;
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .where('uid', isEqualTo: uid)
          //.doc('Zv1c2Cbz0lV819FzkYip')
          .limit(1)
          .get()
          .then((value) => data = value.docs[0]);
      logedUser = UserModel(
          email: data['email'],
          fullname: data['fullname'],
          profilepic: data['profilepic'],
          uid: data['uid']);
      notifyListeners();

          SharedPreferences prefs = await SharedPreferences.getInstance();


String? encodedMap = json.encode(logedUser!.toMap());
print(encodedMap);


prefs.setString('data', encodedMap);
return logedUser;
    } catch (e) {
      log("User detail Fetch Error " + e.toString());
    }
  }

   static  Future<UserModel?> getDII() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();



  final  String? encodedMap  = prefs.getString("data") ;


  Map<String,dynamic> decodedMap = json.decode(encodedMap!);

if(decodedMap !=null){
    UserModel a =UserModel.fromMap(decodedMap);
  
print('${a.email} ++ ${a.fullname}');

  return a;
}


  }

  //delete saved Details
  static Future deleteSavedUserData ()async{
       SharedPreferences prefs = await SharedPreferences.getInstance();


try {
  bool data  =await prefs.remove('data') ;
    log(data.toString());


    
    
} catch (e) {
  log(e.toString()+'deleteSavedUserData Log');
}
  }

 Future register(String email, String password, BuildContext context) async {
  

  
    try {
        loading = true;
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.toString(), password: password.toString());

      User? user = userCredential.user;

      logedUser = UserModel(
        uid: user!.uid,
      );

      String? uid = userCredential.user!.uid;
      UserModel newUser = UserModel(
          uid: uid,
          email: email,
          fullname: "User",
          profilepic:
              "https://images.unsplash.com/photo-1633524588221-ae94a1947870?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fG5vJTIwaW1hZ2V8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60");

      if (logedUser != null) {
        logedUser = newUser;
      
        await _firestore
            .collection('Users')
            .doc(uid)
            .set(newUser.toMap())
            .then((value) {});

        notifyListeners();

  
          fetchUserDetails(logedUser!.uid.toString());

          loading = false;
          //  Navigator.pushNamedAndRemoveUntil(
            // context, HomeScreen.id, (Route<dynamic> route) => false);

            return logedUser;
        
      }else{
        loading=false;
        notifyListeners();
        return logedUser;
      }
    } catch (e) {
      loading = false;
    


      notifyListeners();

      return dialog22(context: context, error: e.toString());
    }
  }

//update Profile
  updateProfile(String name) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(logedUser!.uid)
        .update({"fullname": name})
        .then((value) => log('SUCCESS'))
        .catchError((err) => log("ERROR"));
  }
}
