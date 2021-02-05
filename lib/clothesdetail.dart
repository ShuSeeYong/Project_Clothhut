import 'package:clothhut/clothes.dart';
import 'package:clothhut/user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class ClothesDetail extends StatefulWidget {
  final Clothes clothes;
  final User user;

  const ClothesDetail({Key key, this.clothes, this.user}) : super(key: key);
  @override
  _ClothesDetailState createState() => _ClothesDetailState();
}

class _ClothesDetailState extends State<ClothesDetail> {
  final TextEditingController _remarkscontroller = TextEditingController();
  double screenWidth, screenHeight;
  int selectedQuantity;

  @override
  Widget build(BuildContext context) {
    var quantity =
        Iterable<int>.generate(int.parse(widget.clothes.quantity) + 1).toList();
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
                padding: EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          height: screenHeight / 2.2,
                          width: screenWidth / 1.0,
                          child: CachedNetworkImage(
                            imageUrl:
                                "http://doubleksc.com/clothhut/images/clothesimages/${widget.clothes.image}.jpg",
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.broken_image,
                              size: screenWidth / 2,

                            ),
                          )),
                      Row(
                        children: [
                          Icon(Icons.confirmation_number),
                          SizedBox(width: 20),
                          Container(
                            height: 50,
                            child: DropdownButton(
                              hint: Text(
                                'Quantity',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              value: selectedQuantity,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedQuantity = newValue;
                                  print(selectedQuantity);
                                });
                              },
                              items: quantity.map((selectedQuantity) {
                                return DropdownMenuItem(
                                  child: new Text(selectedQuantity.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  value: selectedQuantity,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      TextField(
                          controller: _remarkscontroller,
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          decoration: InputDecoration(
                              labelText: 'Write your remark',
                              icon: Icon(Icons.notes))),
                      SizedBox(height: 20),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Add to My Cart',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        color: Colors.yellow,
                        textColor: Colors.black,
                        elevation: 15,
                        onPressed: _onOrderDialog,
                      ),
                    ],
                  ),
                ))));
  }

  void _onOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: new Text(
            "Order " + widget.clothes.name + "?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Quantity: " + selectedQuantity.toString() + "?",
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
                _orderClothes();
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

  void _orderClothes() {
    http.post("http://doubleksc.com/clothhut/php/add_order.php", body: {
      "email": widget.user.email,
      "id": widget.clothes.id,
      "quantity": selectedQuantity.toString(),
      "remarks": _remarkscontroller.text,
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
