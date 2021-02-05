import 'dart:convert';
import 'package:clothhut/addcloth.dart';
import 'package:clothhut/cartpage.dart';
import 'package:clothhut/clothes.dart';
import 'package:clothhut/clothesdetail.dart';
import 'package:clothhut/loadComment.dart';
import 'package:clothhut/commentScreen.dart';
import 'package:clothhut/loginscreen.dart';
import 'package:clothhut/sharePage.dart';
import 'package:clothhut/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List clothesList;
  double screenWidth, screenHeight;
  String titlecenter = "No Data Found";
  @override
  void initState() {
    super.initState();
    _loadClothes();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Clothes Screen',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.shopping_cart_sharp,
                color: Colors.tealAccent,
              ),
              onPressed: () {
                _cartScreen();
              }),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              _loadClothes();
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text(widget.user.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            accountEmail:
                new Text(widget.user.email, style: TextStyle(fontSize: 18)),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.yellow,
              child: new Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0, color: Colors.black),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.checkroom,
              color: Colors.green,
            ),
            title: Text('Sell Clothes ', style: TextStyle(fontSize: 15)),
            onTap: () {
              _addClothScreen();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.assignment_rounded,
              color: Colors.green,
            ),
            title: Text('Share Information ', style: TextStyle(fontSize: 15)),
            onTap: () {
              _addShareScreen();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.rate_review_rounded,
              color: Colors.green,
            ),
            title: Text('Review History ', style: TextStyle(fontSize: 15)),
            onTap: () {
              _loadAllComment();
            },
          ),
          Expanded(child: SizedBox(height: 240)),
          Divider(),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.green,
                ),
                title: Text('Logout', style: TextStyle(fontSize: 15)),
                onTap: () {
                  _logout();
                },
              ),
            ),
          ),
        ]),
      ),
      body: Column(
        children: [
          clothesList == null
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
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.8,
                  children: List.generate(clothesList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: new BorderSide(
                                  color: Colors.grey, width: 1.5),
                            ),
                            child: InkWell(
                                onTap: () => _loadClothesDetail(index),
                                onLongPress: () => _deleteClothesList(index),
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    Container(
                                        height: screenHeight / 5.5,
                                        width: screenWidth / 3.5,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "http://doubleksc.com/clothhut/images/clothesimages/${clothesList[index]['image']}.jpg",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 100.0,
                                            height: 100.0,
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
                                    Positioned(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(clothesList[index]['rating'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              )),
                                          Icon(Icons.star, color: Colors.red),
                                        ],
                                      ),
                                      bottom: 50,
                                      right: 10,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      clothesList[index]['name'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "RM " + clothesList[index]['price'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "Quantity: " +
                                          clothesList[index]['quantity'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                          RaisedButton(
                                            color: Colors.yellow,
                                            onPressed: () => _addComment(index),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: Padding(
                                              padding: EdgeInsets.all(1),
                                              child: Text(
                                                "Review",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ]))
                                  ],
                                )))));
                  }),
                ))
        ],
      ),
    );
  }

  void _loadClothes() {
    http.post("http://doubleksc.com/clothhut/php/load_clothes.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "no data") {
        clothesList = null;
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          clothesList = jsondata["clothes"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadClothesDetail(int index) {
    print(clothesList[index]['name']);
    print('RM:' + clothesList[index]['price']);
    Clothes clothes = new Clothes(
        image: clothesList[index]['image'],
        id: clothesList[index]['id'],
        name: clothesList[index]['name'],
        price: clothesList[index]['price'],
        quantity: clothesList[index]['quantity'],
        rating: clothesList[index]['rating']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ClothesDetail(clothes: clothes, user: widget.user)));
  }

  void _cartScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CartPage(user: widget.user)));
  }

  void _addClothScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AddClothesScreen(user: widget.user)));
  }

  void _addComment(int index) {
    print(clothesList[index]['name']);
    Clothes clothes = new Clothes(
        image: clothesList[index]['image'],
        id: clothesList[index]['id'],
        name: clothesList[index]['name']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                CommentScreen(clothes: clothes, user: widget.user)));
  }

  void _addShareScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => SharePage(user: widget.user)));
  }

  _deleteClothesList(int index) {
    print("Delete " + clothesList[index]['name']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: new Text(
            "Delete clothes",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure you want to delete " +
                clothesList[index]['name'] +
                "?",
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
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteClothes(index);
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

  void _deleteClothes(int index) {
    http.post("http://doubleksc.com/clothhut/php/delete_clothes.php", body: {
      "email": widget.user.email,
      "id": clothesList[index]['id'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        _loadClothes();
      } else {
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadAllComment() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                LoadCommentScreen(user: widget.user)));
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: new Text(
            "Are you sure logout Clothhut?",
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
                _log();
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

  void _log() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}
