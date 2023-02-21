import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/components/btn1.dart';
import 'package:chat_app/pages/login_screen.dart';
import 'package:chat_app/pages/registraion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class WelcomeScreen extends StatelessWidget {
    static const String id = 'WelcomeScreen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor:Theme.of(context).scaffoldBackgroundColor ,

      appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColorLight,

        
        title: Text('WelcomeScreen',
        style: Theme.of(context).textTheme.headline6,
        )),

      body: Padding(
        
                padding: EdgeInsets.symmetric(horizontal: 24.0),
        child:Column(
                   mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
                        Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                 //   child: Image.asset('assets/logo.png'),
                 child: Image.asset('assets/logo.png'),
                    height: 30.0,
                  ),
                ),
                Flexible(
                  child: TypewriterAnimatedTextKit(
                    text: ['Flash Chat'],
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

              ],
            ),

                     SizedBox(
              height: MediaQuery.of(context).size.height/10,
            ),
          
            Btn1(context: context, text: 'Log In', press: () {
                    //Go to login screen.
                    Navigator.pushNamed(context, LoginScreen.id);
                  },),


//Registration btn
                            SizedBox(
              height: 20.0,
            ),

            Btn1(context: context,text: 'Sign Up',press: (){
  Navigator.pushNamed(context, RegistrationScreen.id);
            })
          ],
        ) ),
    );
  }
}