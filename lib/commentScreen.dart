import 'package:clothhut/clothes.dart';
import 'package:clothhut/review.dart';
import 'package:clothhut/user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class CommentScreen extends StatefulWidget {
  final Clothes clothes;
  final User user;
  final Review review;
  
  const CommentScreen({Key key, this.clothes, this.user, this.review}) : super(key: key);
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  double screenWidth, screenHeight;
  double sizing = 11.5;
  final TextEditingController _reviewcontroller = TextEditingController();
  final TextEditingController _ratingcontroller = TextEditingController();
  String _review = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.clothes.name,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25),
        ),
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.all(40.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        height: screenHeight / 2.5,
                        width: screenWidth / 1.2,
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://doubleksc.com/clothhut/images/clothesimages/${widget.clothes.image}.jpg",
                          fit: BoxFit.fill,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) => new Icon(
                            Icons.broken_image,
                            size: screenWidth / 2,
                          ),
                        )),
                    TextField(
                        controller: _reviewcontroller,
                        keyboardType: TextInputType.name,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        decoration: InputDecoration(
                            labelText: 'Please write your review',
                            icon: Icon(Icons.comment_rounded))),
                    SizedBox(height: 10),
                    TextField(
                        controller: _ratingcontroller,
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        decoration: InputDecoration(
                            labelText: 'Rating',
                            icon: Icon(Icons.star_rounded))),
                    SizedBox(height: 20),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Add Review',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      color: Colors.yellow,
                      textColor: Colors.black,
                      elevation: 15,
                      onPressed: _onReviewDialog,
                    ),
                  ],
                ),
              ))),
    );
  }

  void _onReviewDialog() {
    _review = _reviewcontroller.text;
    if (_review == "") {
      Toast.show(
        "Please fill your review",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: new Text(
            "Finish Write " + widget.clothes.name + " Comment ?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are You Sure ?",
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
                _addReview();
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

  void _addReview() {
    http.post("https://doubleksc.com/clothhut/php/add_comment.php", body: {
      "image": widget.clothes.image,
      "clothesname" : widget.clothes.name,
      "email": widget.user.email,
      "name": widget.user.name,
      "review": _reviewcontroller.text,
      "rating": _ratingcontroller.text,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
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
