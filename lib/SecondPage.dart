//import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'camera.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:signature/signature.dart';

class SecondPage extends StatefulWidget{
  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();

  File _imageFile;
  StorageReference _reference=FirebaseStorage.instance.ref().child("myimage.jpg");

  String _downloadURL;

  Future getImage() async{
    var image= await ImagePicker.pickImage(source: ImageSource.camera);
    //video= await ImagePicker.pickVideo(source: ImageSource.camera);
    /*else{
      Image=await ImagePicker.pickImage(source: ImageSource.gallery);
    }*/
    setState(() {
      _imageFile = image;
    });
  }

  Future downloadImage() async{
  }

  var _signatureCanvas =  Signature(
    width: 300,
    height: 300,
    backgroundColor: Colors.lightBlueAccent,
  );

  Future uploadImage() async{
      StorageUploadTask uploadTask=_reference.putFile(_imageFile);
      StorageTaskSnapshot taskSnapshot= await uploadTask.onComplete;
      String downloadAddress=await _reference.getDownloadURL();
      setState(() {
        _downloadURL=downloadAddress;
      });

  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Add Customer Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextField(
                controller: t1,
                onSubmitted: (v) => t1.text=v,
                decoration: InputDecoration(
                  labelText: 'Customer Name', 
                ),
                textDirection: TextDirection.ltr,
              ),
              TextField(
                controller: t2,
                onSubmitted: (v) => t2.text=v,
                decoration: InputDecoration(
                  labelText: 'Customer Email', 
                ),
                textDirection: TextDirection.ltr,
              ),
              TextField(
                controller: t3,
                onSubmitted: (v) => t3.text=v,
                decoration: InputDecoration(
                  labelText: 'Business Name', 
                ),
                textDirection: TextDirection.ltr,
              ),
              TextField(
                controller: t4,
                onSubmitted: (v) => t4.text=v,
                decoration: InputDecoration(
                  labelText: 'Customer Address',
                ),
                textDirection: TextDirection.ltr,
              ),
              RaisedButton(
                child: Text('Open Camera'),
                onPressed:() {
                  getImage();
                }
              ),
              _imageFile == null?Container():Image.file(_imageFile,
                  height: 400.0,
                  width: 400.0,
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                      width: 10.0,
                    ),
                    _signatureCanvas,
                    SizedBox(
                      height: 10.0,
                      width: 10.0,
                    ),
                  ],
                ),
                RaisedButton(
                  child:Text('Clear signature'),
                  onPressed: (){
                    _signatureCanvas.clear();
                  },
                ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Upload'),
                    onPressed: (){
                      final CollectionReference reference = Firestore.instance.collection('CustomerData');
                      Firestore.instance.runTransaction((Transaction transaction) async {
                        await reference
                          .add({'businessName':t1.text,
                          'customerName':t2.text,
                          'email':t3.text,
                          'customerAddress':t4.text,
                          'pictureURL':_downloadURL,
                        });
                      });
                      uploadImage();
                      downloadImage();
                      _signatureCanvas.exportBytes().then((Uint8List result){
                        final StorageReference firebaseStorageReference = FirebaseStorage.instance.ref().child('myimage1.jpg');
                        final StorageUploadTask task = firebaseStorageReference.putData(result);
                      });
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text('Cancel'),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}