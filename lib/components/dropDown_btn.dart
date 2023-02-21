import 'package:chat_app/components/Icons.dart';
import 'package:chat_app/components/dialog.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../pages/login_screen.dart';

class DropDownButton extends StatelessWidget {
  const DropDownButton({super.key});

  @override
  Widget build(BuildContext context) {
    

        return PopupMenuButton<String>(
   
          position: PopupMenuPosition.over,
        color: Theme.of(context).primaryColorLight,
        // constraints: BoxConstraints(
        //  minHeight: MediaQuery.of(context).size.height/2,
        //           minWidth: MediaQuery.of(context).size.width/2
         
        // ),
          icon: Icon(Icons.menu),
          onSelected: (String result) {
            switch (result) {
              case 'filter1':
                print('filter 1 clicked');
                break;
              case 'filter2':
                print('filter 2 clicked');
                break;
              case 'clearFilters':
                print('Clear filters');
                break;
              default:
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[

//Profile Screen
             PopupMenuItem<String>(
      
              child: Consumer<ThemeProvider>(
                builder: (context, value, child) {
                  return IconButton( icon:editProfile,
                iconSize: 32,
                color: value.darkThem==true?Theme.of(context).primaryColor:Colors.white, onPressed: () {  
                   Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                },
                
                  
                );
                },
              ),
            ),

            // change theme
             PopupMenuItem<String>(
      
              child: Consumer<ThemeProvider>(
                builder: ((context, value, child) {
                  return IconButton( icon:Icon(value.darkThem==true ?Icons.dark_mode:Icons.light_mode),color: Colors.white, onPressed: ()async {  
                  
                  final themeProvider =Provider.of<ThemeProvider>(context,listen:false);
                           await   themeProvider.changeTheme();
                           Navigator.pop(context);
                  
                },
                
                  
                );
                }),
              ),
          
            ),
    //logout
               PopupMenuItem<String>(
      
              child: IconButton( icon:logout,color: Colors.white, onPressed: ()async {  
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
            authProvider.logedUser!=null;
  
                    await      FirebaseAuth.instance.signOut();
                         authProvider.logedUser=null;

                    await     AuthProvider.deleteSavedUserData();

               Navigator.popUntil(context, (route) => route.isFirst);
            await    Navigator.pushReplacementNamed(context, LoginScreen.id);
                
              },
              
    
              ),
            ),
          ],
       
     
    );
  }
}