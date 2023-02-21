



import 'dart:developer';


import 'package:chat_app/components/btn1.dart';
import 'package:chat_app/components/textfield.dart';
import 'package:chat_app/pages/registraion.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
   static const String id = 'LoginScreen';

 

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  TextEditingController emailController =TextEditingController();

    TextEditingController passwordController =TextEditingController();
    

    @override
  void dispose() {
 
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
         final authProvider =Provider.of<AuthProvider>(context,listen: false);
    return Consumer<AuthProvider>(builder: ((context, value, child) {
    return  Scaffold(
      
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Text('Login',
      style: Theme.of(context).textTheme.headline6,
      
      
      ),
      centerTitle: true,

      ),

      body: value.loading ==true ?
      const Center(child: CircularProgressIndicator())
      :
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 34.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              controller: emailController,
              // onChanged: (value) {
              //   //Do something with the user input.
              //   email = value;
              // },
            
           
              decoration: textFieldDecoration.copyWith(
                hintText: 'Enter your email',
             hintStyle: TextStyle(

                  color: Theme.of(context).primaryColor
                ),
               
                focusedBorder: UnderlineInputBorder(
borderSide: BorderSide(color: Theme.of(context).primaryColor)
                ),
                    enabledBorder: UnderlineInputBorder(
borderSide: BorderSide(color: Theme.of(context).primaryColorLight)
                ),
              ),
                style: TextStyle(  color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: passwordController,
              // onChanged: (value) {
              //   //Do something with the user input.
              //   password = value;
              // },
               decoration: textFieldDecoration.copyWith(
                hintText: 'Enter your Password',
             hintStyle: TextStyle(
                  color: Theme.of(context).primaryColor
                ),
               
                focusedBorder: UnderlineInputBorder(
borderSide: BorderSide(color: Theme.of(context).primaryColor)
                ),
                    enabledBorder: UnderlineInputBorder(
borderSide: BorderSide(color: Theme.of(context).primaryColorLight)
                ),
              ),
               style: TextStyle(  color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              height: 24.0,
            ),
          

            Btn1(context: context, text: 'Log In', press: ()async{
         
     if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
       var user =await value.login(emailController.text.trim(), passwordController.text.trim(),context);
       log('LOSSA  ${user.toString()}');
               
                  }else{
                    print('FILL all Fields');
                  }
            }),

            TextButton(onPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            }, child: RichText(text: TextSpan(
              text: 'Not have account \t\t',
              children: <TextSpan>[
                TextSpan(text: 'SignUp',
                style: TextStyle(color: Colors.blue[600],fontSize: 18)
                )
              ]
            ),
            
          
            ))
          ],
        ),
      ),
    );
    }));
  }
}