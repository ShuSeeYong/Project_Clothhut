import 'dart:convert';
import 'package:clothhut/post.dart';
import 'package:clothhut/user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class CommentPostClothesScreen extends StatefulWidget {
  final Post postss;
  final User userss;

  CommentPostClothesScreen(this.postss, this.userss);
  @override
  _CommentPostClothesScreenState createState() =>
      _CommentPostClothesScreenState(postss, userss);
}

class _CommentPostClothesScreenState extends State<CommentPostClothesScreen> {
  Post posts;
  User users;
  _CommentPostClothesScreenState(Post postss, User userss);
  List postList;
  List commentList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading post...";
  final TextEditingController _commentcontroller = TextEditingController();
  String _caption = "";

  @override
  void initState() {
    super.initState();
    posts = widget.postss;
    users = widget.userss;
    _loadDetails();
    _loadComment();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text(
              widget.postss.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  _loadComment();
                },
              ),
            ]),
        body: Column(children: [
          Container(
              padding: EdgeInsets.all(3),
              child: (Column(
                children: [
                  Container(
                      child: Column(
                    children: [
                      Container(
                          child: Column(children: [
                        Container(
                            height: 330,
                            width: 230,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://doubleksc.com/clothhut/images/clothesimages/${posts.image}.jpg",
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                              errorWidget: (context, url, error) => new Icon(
                                Icons.broken_image,
                                size: screenWidth / 2,
                              ),
                            )),
                        SizedBox(height: 5),
                        Row(children: [
                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                          Text("Name: "+posts.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ]),
                        Column(
                          children: <Widget>[
                          Align(alignment: Alignment(-0.93,0),
                          child: Container( 
                            child:
                          Text("Description: "+posts.description,style: TextStyle(
                                  fontSize: 16)),
                          ))]),
                      ])),
                    ],
                  )),
                ],
              ))),
          Expanded(
            child: SingleChildScrollView(
              child: commentList == null
                  ?
                  Container(
                      child: Container(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text("No Comment"),
                          )))
                  : Container(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: commentList.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                print(commentList.length);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(commentList[index]['username'],
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            "     -" +
                                                commentList[index]
                                                    ['datecomment'],
                                            style: TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(commentList[index]['caption'],
                                        style: TextStyle(fontSize: 15)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              }))),
            ),
          ),
          TextField(
              controller: _commentcontroller,
              decoration: InputDecoration(
                  labelText: "Comment",
                  suffixIcon: IconButton(
                    onPressed: () {
                      _updatenewcomment();
                    },
                    icon: Icon(Icons.send),
                  ))),
        ]));
  }

  void _loadDetails() {
    print("Load Post Thing");
    http.post("https://doubleksc.com/clothhut/php/load_post.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        postList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); 

          postList = jsondata["post"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadComment() {
    http.post("http://doubleksc.com/clothhut/php/load_postcomment.php", body: {
      "name":
          widget.postss.name, 
    }).then((res) {
      print(res.body);

      if (res.body == "nodata") {
        print("commentList is null");
        commentList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body); 

          commentList = jsondata["comments"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _updatenewcomment() {
    final dateTime = DateTime.now();
    _caption = _commentcontroller.text;

    http.post("http://doubleksc.com/clothhut/php/add_postcomment.php", body: {
      "name": posts.name,
      "caption": _caption,
      "useremail": users.email,
      "username": users.name,
      "datecomment": "-${dateTime.microsecondsSinceEpoch}",
    }).then((res) {
      print(res.body);

      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
}
