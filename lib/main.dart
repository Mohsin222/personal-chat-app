

import 'dart:developer';

import 'package:chat_app/models/firebaseHelper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/chat_room.dart';

import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/pages/login_screen.dart';
import 'package:chat_app/pages/registraion.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/pages/welcome_screen.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_room_provider.dart';
import 'package:chat_app/providers/function_provider.dart';
import 'package:chat_app/providers/profile_update_provider.dart';
import 'package:chat_app/providers/theme_provider.dart';
import 'package:chat_app/theme/theme_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  bool currentTheme =await StyleTheme.getTheme();

  User? currentUser = FirebaseAuth.instance.currentUser;

  if(currentUser !=null){
    //  UserModel? thisUserModel = await FirebaseHelper.getUserModelbyId(currentUser.uid);
     UserModel? thisUserModel = await AuthProvider.getDII();
       runApp( MyApp1(userModel: thisUserModel,));
    log('NOT NULLLLLLLL');
     
  }else{
      runApp( MyApp());
        log('NULLLLLLLL');
  }

}

class MyApp extends StatelessWidget {

  final currentTheme;

  const MyApp({super.key, this.currentTheme});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => AuthProvider()),
         ChangeNotifierProvider(create: (_) => ChatRoomProvider()),
          ChangeNotifierProvider(create: (_) => FunctionsProvider()),
              ChangeNotifierProvider(create: (_) => ProfileUpdate()),
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child:Consumer<ThemeProvider>(
   
        builder: (context, value, child) {
               final authProvider =Provider.of<AuthProvider>(context,listen:false);
           
                final themeProvider =Provider.of<ThemeProvider>(context,listen:false);
              //  log(authProvider.logedUser.toString());
          return MaterialApp(
        title: 'Flutter Demo',

      //  home: WelcomeScreen() ,
     theme:value.darkTheme?StyleTheme.darkTheme
              : StyleTheme.lightTheme,
         initialRoute:WelcomeScreen.id ,
        // home: HomeScreen(),
        routes: {
             HomeScreen.id: (context) => HomeScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
       LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
                 
    
          ChatRoom.id:(context)=>ChatRoom(),
          SearchScreen.id:(context)=>SearchScreen(),
        }
      );
        },
      )
    );
  }
}



class MyApp1 extends StatelessWidget {
  final userModel;
 

  const MyApp1({super.key,this.userModel=null});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => AuthProvider()),
         ChangeNotifierProvider(create: (_) => ChatRoomProvider()),
          ChangeNotifierProvider(create: (_) => FunctionsProvider()),
              ChangeNotifierProvider(create: (_) => ProfileUpdate()),
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child:Consumer<ThemeProvider>(
   
        builder: (context, value, child) {
               final authProvider =Provider.of<AuthProvider>(context,listen:false);
                   authProvider.logedUser=userModel;
                final themeProvider =Provider.of<ThemeProvider>(context,listen:false);
              //  log(authProvider.logedUser.toString());
          return MaterialApp(
        title: 'Flutter Demo',

    
     theme:value.darkTheme?StyleTheme.darkTheme
              : StyleTheme.lightTheme,
         initialRoute:HomeScreen.id ,
        // home: HomeScreen(),
        routes: {
             HomeScreen.id: (context) => HomeScreen(),
          WelcomeScreen.id: (context) => const WelcomeScreen(),
       LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
                 
    
          ChatRoom.id:(context)=>ChatRoom(),
          SearchScreen.id:(context)=>SearchScreen(),
        }
      );
        },
      )
    );
  }
}

