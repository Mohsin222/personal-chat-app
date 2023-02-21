import 'dart:developer';
import 'dart:io';

import 'package:chat_app/components/dialog.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class ProfileUpdate extends ChangeNotifier{

    File? imageFile;
  File? croppedFile;
    String url='';
  String fullname='';
  String convertText='';
  bool success=false;

  void pickIamge()async{
    final ImagePicker _picker = ImagePicker();

XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

     print(pickedFile);

 if (pickedFile != null) {
        File image = File(pickedFile.path);
        cropTheImage(image);
  
     log('PROVIDER PICK LOG');
    notifyListeners();
     
    }else{
      print('FILE IS EMPTY');
    }

  
  }
  bool cropImage =false;
    cropTheImage(File imageFile1) async {
try {
      cropImage = true;
    var cropped = (await ImageCropper.platform.cropImage(
      sourcePath: imageFile1.path,
      uiSettings: [
        AndroidUiSettings(lockAspectRatio: false),
      ],
    ));
    croppedFile = File(cropped!.path);

    imageFile=croppedFile;
    
      log('PROVIDER CRIO LOG');
        notifyListeners();
} catch (e) {
  log(e.toString());
}
    // setState(() {});
  }


//upload function
Future uploadFile({required AuthProvider authProvider, required BuildContext context}) async {    
  //  final authProvider =Provider.of<AuthProvider>(context, listen: false);
if(imageFile !=null){
           deleteOldProfileP(authProvider.logedUser!.uid.toString());
String name = DateTime.now().microsecondsSinceEpoch.toString();
var image = FirebaseStorage.instance.ref('profile').child('/${name}.jpg');
UploadTask task = image.putFile(imageFile!);
TaskSnapshot snapshot = await task;
 url = await snapshot.ref.getDownloadURL(); 
 if(fullname ==''){
fullname=authProvider.logedUser!.fullname.toString();
 }

      await FirebaseFirestore.instance.collection('Users').doc(authProvider.logedUser!.uid).update({
       'profilepic':url,
       'fullname':fullname
      }).then((value) {
        authProvider.fetchUserDetails(authProvider.logedUser!.uid.toString());
        success=true;

        imageFile=null;
        croppedFile=null;
        fullname='';

   
      }).catchError( (err){
        dialog22(context: context, error: err);
      });
notifyListeners();
  
}else{
   if(fullname ==''){
fullname=authProvider.logedUser!.fullname.toString();
 }
   await FirebaseFirestore.instance.collection('Users').doc(authProvider.logedUser!.uid).update({
       'profilepic':authProvider.logedUser!.profilepic,
       'fullname':fullname
      }).then((value) {
        authProvider.fetchUserDetails(authProvider.logedUser!.uid.toString());
success=true;
  imageFile=null;
        croppedFile=null;
        fullname='';

    
      }).catchError( (err){
        dialog22(context: context, error: err);
      });

      notifyListeners();
   
}
notifyListeners();
return success;

 } 



deleteOldProfileP(String uid,)async{

 
   UserModel? userModel;
   DocumentSnapshot docSnap =  await FirebaseFirestore.instance.collection('Users').doc(uid).get();


  //  userModel = UserModel.fromMap(docSnap.data() as Map<String,dynamic>);
     if(docSnap.data() !=null){
      userModel = UserModel.fromMap(docSnap.data() as Map<String,dynamic>);
      

  await FirebaseStorage.instance.refFromURL(userModel.profilepic.toString()).delete().then((value) {

    log('DELEYED SUCCESS');
  }).catchError((err){
log(err.toString());
  });
    }else{
      log('NUL:LLAA');
    }



  //  await FirebaseStorage.instance.refFromURL(url).delete();

}
}