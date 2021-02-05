import 'dart:io';
import 'dart:convert';
import 'package:clothhut/clothes.dart';
import 'package:clothhut/post.dart';
import 'package:clothhut/user.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class AddPostClothesScreen extends StatefulWidget {
  final Post post;
  final User user;
  final Clothes clothes;

  const AddPostClothesScreen({Key key, this.post, this.user,this.clothes}) : super(key: key);
  @override
  _AddPostClothesScreenState createState() => _AddPostClothesScreenState();
}

class _AddPostClothesScreenState extends State<AddPostClothesScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _descontroller = TextEditingController();
  String posttype = "Post";
  String _name = "";
  String _description = "";
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/camera.png';
  List postList;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post New Clothes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () => {_onPictureSelection()},
                        child: Container(
                          height: screenHeight / 3.2,
                          width: screenWidth / 1.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              width: 3.0,
                              color: Colors.grey,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        )),
                    SizedBox(height: 5),
                    Text("Click image to post new clothes picture",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black)),
                    SizedBox(height: 5),
                    TextField(
                        controller: _namecontroller,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Title',
                            icon: Icon(Icons.wysiwyg_rounded))),
                    SizedBox(height: 10),
                     TextField(
                        controller: _descontroller,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        keyboardType: TextInputType.name,
                        maxLines:3,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            icon: Icon(Icons.add_comment))),
                    SizedBox(height: 10),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 200,
                      height: 50,
                      child: Text('Post New Clothes',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      color: Colors.deepOrange,
                      textColor: Colors.black,
                      elevation: 15,
                      onPressed: newPostClothesDialog,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ))),
    );
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.amber,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        color: Colors.grey[200],
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        color: Colors.grey[200],
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.orange,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void newPostClothesDialog() {
    _name = _namecontroller.text;
    _description = _descontroller.text;

    if (_name == "" && _description == "") {
      Toast.show(
        "Please fill all the required fields.",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        backgroundColor: Colors.black,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: new Text(
            "Post a new clothes?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onAddPost();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onAddPost() {
    _name = _namecontroller.text;
    _description = _descontroller.text;
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post("http://doubleksc.com/clothhut/php/add_post.php",
        body: {
          "email":widget.user.email,
          "username":widget.user.name,
          "name": _name,
          "description":_description,
          "encoded_string": base64Image,
        }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", 
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
            backgroundColor: Colors.black);
        Navigator.pop(context);
      } else {
        Toast.show("Failed", 
             context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
            backgroundColor: Colors.black);
      }
    }).catchError((err) {
      print(err);
    });
  }
}