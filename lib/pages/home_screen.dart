import 'dart:developer';

import 'package:chat_app/components/dropDown_btn.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/firebaseHelper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/chat_room.dart';
import 'package:chat_app/pages/login_screen.dart';

import 'package:chat_app/pages/search_page.dart';

import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_room_provider.dart';
import 'package:chat_app/providers/function_provider.dart';
import 'package:chat_app/providers/profile_update_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'Homescreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          Navigator.pushNamed(context, SearchScreen.id);
        },
        child: const Icon(Icons.search),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Consumer<AuthProvider>(
          builder: (context, value, child) {
            return Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(value.logedUser!.profilepic ??
                      'https://plus.unsplash.com/premium_photo-1663013582031-2721882c257b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxM3x8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60'),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(child: Text(value.logedUser!.fullname ?? ''))
              ],
            );
          },
        ),
        automaticallyImplyLeading: false,
        actions:  [
          DropDownButton(),

//           IconButton(onPressed: (){
// final profileProvider =Provider.of<ProfileUpdate>(context,listen: false);
// profileProvider.deleteOldProfileP(authProvider.logedUser!.uid.toString());
            
//           } ,icon: Icon(Icons.add))
        ],
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(
              child: Container(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatroom")
                    .where("participants.${authProvider.logedUser!.uid}",
                        isEqualTo: true)
                    // .orderBy('createdon')

                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot chatRoomSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                          itemCount: chatRoomSnapshot.docs.length,
                          itemBuilder: ((context, index) {
                            ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                                chatRoomSnapshot.docs[index].data()
                                    as Map<String, dynamic>);

                            Map<String, dynamic> participants =
                                chatRoomModel.participants!;
                            List<String> participantKeys =
                                participants.keys.toList();

                            participantKeys.remove(authProvider.logedUser!.uid);

                            return FutureBuilder(
                                //in this we use id to fech user details function in Helperclass
                                future: FirebaseHelper.getUserModelbyId(
                                    participantKeys[0]),
                                builder: ((context, userData) {
                                  if (userData.hasData) {
                                    UserModel targetUser =
                                        userData.data as UserModel;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      child: ListTile(
                                        tileColor: Theme.of(context).cardColor,
                                        onTap: () async {
                                          final chatRoomProvider =
                                              Provider.of<ChatRoomProvider>(
                                                  context,
                                                  listen: false);

                                          ChatRoomModel? chatRoomModel =
                                              await chatRoomProvider
                                                  .getChatRoomModel(
                                                      logedUser: authProvider
                                                          .logedUser!,
                                                      targetUser: targetUser);
                                          if (chatRoomModel != null) {
                                            // Navigator.pop(context);

                                            Navigator.pushNamed(
                                                context, ChatRoom.id);
                                          }
                                        },
                                        leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                targetUser.profilepic
                                                    .toString())),
                                        title: Text(
                                            targetUser.email == null
                                                ? ''
                                                : targetUser.email.toString(),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        subtitle: Text(
                                            chatRoomModel.lastMessage
                                                .toString(),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                                    );
                                  } else {
                                    return const Center(child: Text('No Chats'));
                                  }
                                }));
//
                          }));
                    } else if (snapshot.hasError) {
                      return Text("An error occured!",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor));
                    } else {
                      return Text("No Chats",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor));
                    }
                  } else {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                }),
          ))
        ],
      )),
    );
  }
}
