import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:intl/intl.dart';

class LoadCommentScreen extends StatefulWidget {
  final User user;

  const LoadCommentScreen({Key key, this.user}) : super(key: key);

  @override
  _LoadCommentScreenState createState() => _LoadCommentScreenState();
}

class _LoadCommentScreenState extends State<LoadCommentScreen> {
  List reviewlist;
  List clothesList;

  String titlecenter = "Loading review ...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadReview();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
           title: Text('Comment History',
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
                _loadReview();
              },
            ),
          ]),
      body: Column(
        children: [
          reviewlist == null
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
                  childAspectRatio: (screenWidth / screenHeight) / 0.23,
                  children: List.generate(reviewlist.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            child: InkWell(
                                child: SingleChildScrollView(
                                    child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 130,
                                width: 130,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://doubleksc.com/clothhut/images/clothesimages/${reviewlist[index]['image']}.jpg",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 60.0,
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                        const Radius.circular(20.0),
                                      ),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      new Icon(
                                    Icons.broken_image,
                                    size: screenWidth / 2,
                                  ),
                                )),
                                SizedBox(width:20),
                                Column(
                                  crossAxisAlignment : CrossAxisAlignment.start,
                                  children: [
                            Text(
                              "Clothes name : " +
                                  reviewlist[index]['clothesname'],
                                  textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              "Name : " + reviewlist[index]['name'],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: 
                                     Text("Review : " + reviewlist[index]['review'],
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),),
                                  )
                              )
                              ]),
                            Text(
                              "Rating : " + reviewlist[index]['rating'],
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        )])))));
                  }),
                ))
        ],
      ),
    ));
  }

  void _loadReview() {
    http.post("http://doubleksc.com/clothhut/php/load_comment.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        reviewlist = null;
        setState(() {
          titlecenter = "No data";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          reviewlist = jsondata["review"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}

