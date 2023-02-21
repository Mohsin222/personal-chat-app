import 'dart:developer';

import 'package:chat_app/components/btn1.dart';
import 'package:chat_app/components/dialog.dart';
import 'package:chat_app/components/textfield.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistraionScreen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email = '';

  String password = '';

  TextEditingController emailController = TextEditingController(text: '');

  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController cpasswordController = TextEditingController(text: '');

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: ((context, value, child) {
      return Scaffold(
        appBar: AppBar(
             backgroundColor: Theme.of(context).primaryColorLight,
          title: Text('SIGN UP',
           style: Theme.of(context).textTheme.headline6,
          )),
        body: value.loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                          // onChanged: (value) {
    
                          //   email = value;
                          // },
                          controller: emailController,
    
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFieldDecoration.copyWith(
                            hintText: 'Enter your Email',
                            hintStyle: TextStyle(
                                color: Theme.of(context).primaryColor),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).primaryColorLight)),
                          ),
                           style: TextStyle(  color: Theme.of(context).primaryColor),
                          ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        // onChanged: (value) {
                        //   password = value;
                        // },
               controller: passwordController,
                        keyboardType: TextInputType.number,
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
                        height: 8.0,
                      ),
                      TextField(
  
                        controller: cpasswordController,
                        //    obscureText: true,
                        keyboardType: TextInputType.number,
                          decoration: textFieldDecoration.copyWith(
                hintText: 'Enter conform Password',
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
                        height: 20.0,
                      ),
                

                          Btn1(context: context, text: 'Sign in', press:() async {
                            if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                              if (passwordController.text == cpasswordController.text) {
                                final authProvider = Provider.of<AuthProvider>(
                                    context,
                                    listen: false);
                 var user=          await      authProvider.register(emailController.text.trim(), passwordController.text.trim(), context);
              
                 log(user.toString());
                 if(user !=null){
                        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.id, (Route<dynamic> route) => false);
                 }
                              } else {
                                log('Password not match');
                                dialog22(context: context, error: 'Password not match');
                              }
                            }

                            // email='';
                            //      password='';
                          },)
                    ]),
              ),
      );
    }));
  }
}
