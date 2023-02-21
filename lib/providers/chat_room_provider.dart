import 'dart:async';
import 'dart:developer';

import 'package:chat_app/models/MessageModel.dart';
import 'package:chat_app/models/chat_room_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../pages/chat_room.dart';

class ChatRoomProvider extends ChangeNotifier{

    UserModel? targetedUser;
    UserModel? userModel;
  ChatRoomModel? chatRoom;
  late final User firebaseUser;
 


  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<ChatRoomModel?> getChatRoomModel({required UserModel targetUser, required UserModel logedUser})async{
//find chatroom and create chat room
   QuerySnapshot snapshot= await FirebaseFirestore.instance.collection('chatroom')
    .where('participants.${logedUser.uid}',isEqualTo: true)
    .where('participants.${targetUser.uid}',isEqualTo: true)
    .get();
    notifyListeners();


    if(snapshot.docs.length >0){
        

      log('Chatroom already created');
    
   var docData =   snapshot.docs[0].data();
   ChatRoomModel existingChatRoom =ChatRoomModel.fromMap(docData as Map<String,dynamic>);
 targetedUser=  targetUser;
 userModel =logedUser;
   chatRoom =existingChatRoom;
         notifyListeners();  

notifyListeners();
    }else{
    

          var uuid = Uuid();
var id =uuid.v1();
ChatRoomModel newChatRoom =ChatRoomModel(
  chatroomid:id,
  createdon: DateTime.now(),
  participants: {
logedUser.uid.toString():true,
    targetUser.uid.toString():true
  },
  lastMessage: ""
);


        await     _firestore.collection('chatroom').doc(newChatRoom.chatroomid).set(newChatRoom.toMap()).then((value) => log("New Chat room Created Succcessfully"));
    targetedUser=targetUser;
    userModel =logedUser;
  chatRoom= newChatRoom;




  notifyListeners();
    }

 return   chatRoom;
  }


@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    log('DISPOSE');
        messageTextController.dispose();
  }
  //send messages
var messageTextController = TextEditingController(text: null);
  void sendMessage(BuildContext context, String text)async{
  

    String msg =text ;
    log(msg.toString());

    if(msg !=null && msg !=''){
       var uuid = Uuid();
      MessageModel newMessage =MessageModel(
        messageid: uuid.v1(),
        sender: userModel!.email.toString(),
        createdon: DateTime.now(),
        text: msg.toString(),
        seen: false
      );

              _firestore.collection('chatroom')
              .doc(chatRoom!.chatroomid)
              .collection('messages')
              .doc(newMessage.messageid)
              .set(newMessage.toMap());

              log('MESSAGE SEND');


              _firestore.collection('chatroom')
              .doc(chatRoom!.chatroomid)
             .update({
              'lastmessage':msg.toString()
             }).then((value) => print('Last message adeed'));
              

              log('MESSAGE SEND');
              messageTextController.clear();
              notifyListeners();
                  }else{
    // SnackBar(content: Text('ENter some Text'),backgroundColor: Colors.red,);
      log('MESSAGE Not SEND');
      notifyListeners();
    }
  }


}