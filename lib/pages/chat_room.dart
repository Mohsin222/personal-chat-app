import 'dart:developer';

import 'package:chat_app/components/textfield.dart';
import 'package:chat_app/models/MessageModel.dart';
import 'package:chat_app/providers/chat_room_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
FirebaseFirestore _firestore = FirebaseFirestore.instance;
class ChatRoom extends StatelessWidget {
    static const String id = 'chat_room';

  var messageTextController = TextEditingController(text: null);

 
  @override
  Widget build(BuildContext context) {
               final chatRoomProvider =Provider.of<ChatRoomProvider>(context,listen: false);
           
        


        return Scaffold(
          
      appBar: AppBar(
         backgroundColor: Theme.of(context).primaryColorLight,
        title:
         Consumer<ChatRoomProvider>(builder:((context, value, child) {
        
    return     Row(
       children: [
        CircleAvatar(backgroundImage: NetworkImage(
        
     chatRoomProvider.targetedUser ==null ?
    
    'https://plus.unsplash.com/premium_photo-1663013582031-2721882c257b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxM3x8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60'
   :value.targetedUser!.profilepic.toString()),),

      SizedBox(width: 5,),
      Text(chatRoomProvider.targetedUser!.fullname ?? '',
      style: Theme.of(context).textTheme.headline6,
      )
       ],
        );

         }
      ),
         ),
      ),

      body: Container(
        // height: MediaQuery.of(context).size.height,
        child:Column(
          children: [
            Expanded(child: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("chatroom")
                .doc(chatRoomProvider.chatRoom!.chatroomid)
                .collection('messages')
                .orderBy('createdon')
                .snapshots(),

                builder: ((context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Center(child: CircularProgressIndicator());
                // }
                 if (snapshot.connectionState == ConnectionState.active){
                  if(snapshot.hasData){
QuerySnapshot dataSnapshot =snapshot.data as QuerySnapshot;

   

return ListView.builder(
  itemCount: dataSnapshot.docs.length,
  itemBuilder: (context,index){
    MessageModel  currentMessage =MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String,dynamic>);
    bool isTrue = false;
                      if (chatRoomProvider.userModel!.email == currentMessage.sender) {
                        isTrue = true;
                      }
    return Container(
      alignment: isTrue ? Alignment.centerLeft:Alignment.centerRight,
      child: Container(
      margin: EdgeInsets.all(5),

        constraints: BoxConstraints(maxWidth:  MediaQuery.of(context).size.width/2,
        minWidth: 20
        ),
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(10),
          color: isTrue ?Theme.of(context).primaryColorLight :Theme.of(context).cardColor
        ),
        child:ListTile(
          title:   Text(currentMessage.text.toString(),
          style: TextStyle(color: Theme.of(context).primaryColor,
            fontSize: 12
          ),
          ),
         subtitle:  Text(chatRoomProvider.userModel!.fullname.toString(),
            style: TextStyle(color: Theme.of(context).primaryColor,
            fontSize: 10
            ),
        ),
      ),
    ));
  });
                  }
                  else if(snapshot.hasError){
return const Center(child: Text('An error occurs please check your connection'),);
                  }else{
                    return Center(child: Text('Say Hi to ${chatRoomProvider.targetedUser!.fullname}'),);
                  }
                }
                else{
                         return Center(child: CircularProgressIndicator());
                }
                }),
              ),
            )),
               Container(
            decoration: BoxDecoration(
            // color: Color.fromARGB(255, 194, 192, 192),
              border: Border(
             
              ),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: null,
                      // decoration: InputDecoration(hintText: 'Message',
                
                      // ),
                      controller: chatRoomProvider.messageTextController,
                      decoration: textFieldDecoration.copyWith(
                hintText: 'Message',
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
              style: TextStyle(color: Theme.of(context).primaryColor,),
              
                 
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      // sendMessage(context);
                          // final chatRoomProvider =Provider.of<ChatRoomProvider>(context,listen: false);
                    
                          chatRoomProvider.sendMessage(context, chatRoomProvider.messageTextController.text.trim());
                          messageTextController.clear();
    
                    },
                    icon: Icon(Icons.send,
                    color: Theme.of(context).primaryColorLight,
                    ))
              ],
            ),
          ),
          ],
        ),
      ),
    );

  }
}