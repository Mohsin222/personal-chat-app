import 'package:chat_app/components/btn1.dart';
import 'package:chat_app/components/textfield.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/chat_room.dart';
import 'package:chat_app/pages/welcome_screen.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_room_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
 
   static const String id = 'SearchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
   String searchText='';
  TextEditingController searchController= TextEditingController();

  @override
  Widget build(BuildContext context) {
       final authProvider =Provider.of<AuthProvider>(context,listen: false);
    return Scaffold(
     

      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: CircleAvatar(backgroundImage: NetworkImage(
     
      authProvider.logedUser!.profilepic ??
    'https://plus.unsplash.com/premium_photo-1663013582031-2721882c257b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxM3x8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60'
      ),),
      //  automaticallyImplyLeading: false,
       actions: [
        IconButton(onPressed: (){
          final FirebaseAuth _auth = FirebaseAuth.instance;
          Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (Route<dynamic> route) => false);
          _auth.signOut();
        }, icon: Icon(CupertinoIcons.xmark_rectangle))
       ],
      ),
      

      body: Container(
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        child: Column(
        children: [
                SizedBox(
            height: MediaQuery.of(context).size.height/14,
          ),
          TextField(
          controller: searchController,
          // onChanged: ((value) {
          //   searchText=value;
          // }),
           
            decoration:textFieldFunction(context: context, hintTxt: 'Search User'),
                      style: TextStyle(  color: Theme.of(context).primaryColor)
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/14,
          ),

          Btn1(context: context, text: 'Seacrh', press: (){
            setState(() {
              
            });
            
          }),
          Expanded(child: Container(
        

child:  StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Users").where("email", isEqualTo: searchController.text.trim()).where("email", isNotEqualTo: authProvider.logedUser!.email).snapshots(),
                builder: (context, snapshot) {


                 
                  if(snapshot.connectionState == ConnectionState.active) {
                    if(snapshot.hasData) {
                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

                      if(dataSnapshot.docs.length > 0) {
                    
                        Map<String, dynamic> userMap = dataSnapshot.docs[0].data() as Map<String, dynamic>;
 
                        UserModel searchedUser = UserModel.fromMap(userMap);

                        return ListTile(
                          onTap: () async {

                    
                final chatRoomProvider =Provider.of<ChatRoomProvider>(context,listen: false);             



ChatRoomModel? chatRoomModel=await chatRoomProvider.getChatRoomModel(logedUser:authProvider.logedUser!,targetUser: searchedUser);
                            if(chatRoomModel !=null){
                              Navigator.pop(context);
                           
                              Navigator.pushNamed(context, ChatRoom.id);
                   
                            }
                          },
                                 leading: CircleAvatar(
                            backgroundImage: NetworkImage(searchedUser.profilepic!),
                            backgroundColor: Colors.grey[500],
                          ),
                          subtitle: Text(searchedUser.email.toString())
                          
                        );
                      }
                      else {
                        return Text("No results found!");
                      }
                      
                    }
                    else if(snapshot.hasError) {
                      return Text("An error occured!");
                    }
                    else {
                      return Text("No results found!");
                    }
                  }
                  else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
              ),
          ))
        ],
      )),
    );
  }
}