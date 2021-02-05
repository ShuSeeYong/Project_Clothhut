import 'dart:convert';
import 'package:clothhut/addPostClothesScreen.dart';
import 'package:clothhut/comPostCloth.dart';
import 'package:clothhut/post.dart';
import 'package:clothhut/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';

class SharePage extends StatefulWidget {
  final User user;
  final Post post;

  const SharePage({Key key, this.user, this.post}) : super(key: key);

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  List postList;
  double screenWidth, screenHeight;
  String titlecenter = "No Data Found";
  bool liked = false;
  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothes Share',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              _loadPost();
            },
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.post_add_rounded),
              label: "Add New Post",
              labelBackgroundColor: Colors.white,
              onTap: _addPostClothScreen),
        ],
      ),
      body: Column(
        children: [
          postList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 1.1,
                  children: List.generate(postList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                            semanticContainer: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            elevation: 10,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    Container(
                                        height: 550,
                                         width: 350,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "http://doubleksc.com/clothhut/images/clothesimages/${postList[index]['image']}.jpg",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 45.0,
                                            height: 45.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  new BorderRadius.all(
                                                const Radius.circular(20.0),
                                              ),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              new CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(
                                            Icons.broken_image,
                                            size: screenWidth / 2,
                                          ),
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Stack(
                                              alignment: Alignment(1.2,0),
                                              children: <Widget>[
                                                Padding(
                                                padding: EdgeInsets.fromLTRB(50,0,0,0)),
                                                LikeButton(size:25,likeBuilder:(bool like){
                                                  return Icon(Icons.favorite,
                                                  color:like ? Colors.red : Colors.grey);                                                }),
                                              ],
                                            ),
                                            Stack(
                                              alignment: Alignment(0, 0),
                                              children: <Widget>[
                                                IconButton(
                                                  icon:
                                                      Icon(Icons.comment_rounded),
                                                  color: Colors.black,
                                                  onPressed: () {
                                                    _addPostComment(index);
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0)),
                                      Text(
                                        "Shared by: " +
                                            postList[index]['username'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )
                                    ]),
                                    SizedBox(height: 5),
                                    Row(children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0)),
                                      Text(
                                        "Title: " + postList[index]['name'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )
                                    ]),
                                    SizedBox(height: 5),
                                    Row(children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0)),
                                      Text(
                                        "Description: " +
                                            postList[index]['description'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )
                                    ]),
                                  ],
                                )))));
                  }),
                ))
        ],
      ),
    );
  }

  void _loadPost() {
    http.post("http://doubleksc.com/clothhut/php/load_post.php", body: {}).then(
        (res) {
      print(res.body);
      if (res.body == "no data") {
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

  _addPostComment(int index) {
    Post post = new Post(
        image: postList[index]['image'],
        id: postList[index]['id'],
        email: postList[index]['email'],
        username: postList[index]['username'],
        name: postList[index]['name'],
        description: postList[index]['description']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                CommentPostClothesScreen(post, widget.user)));
  }

  void _addPostClothScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AddPostClothesScreen(user: widget.user)));
  }
}
