import 'dart:async';
import 'dart:convert';
import 'package:clothhut/billscreen.dart';
import 'package:clothhut/clothes.dart';
import 'package:clothhut/clothesdetail.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'user.dart';

class CartPage extends StatefulWidget {
  final User user;
  final Clothes clothes;

  const CartPage({Key key, this.user, this.clothes}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List cartList;
  double screenWidth, screenHeight, rating;
  String titlecenter = "Loading Cart...";
  double totalPrice = 0.0;
  String _homeloc = "searching...";
  String gmaploc = "";
  double sizing = 11.5;
  double restdel = 0.0;
  double delcharge = 0.0;
  double payable = 0.0;
  int _radioValue = 0;
  String _delivery = "Pickup";
  bool _visible = false;
  bool _stdeli = false;
  bool _stpickup = true;
  Set<Marker> markers = Set();
  double latitude, longitude;
  CameraPosition _userpos;
  CameraPosition _home;
  GoogleMapController gmcontroller;
  MarkerId markerId1 = MarkerId("12");
  Position _currentPosition;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _timeController = TextEditingController();
  int numcart = 0;
  final formatter = new NumberFormat("#,##");
  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Container(
              decoration: new BoxDecoration(
                color: Colors.pink,
              ),
              height: screenHeight / 8.0,
              width: screenWidth / 0.3,
              child: Card(
                child: SingleChildScrollView(
                    child: Column(children: [
                  Text(widget.user.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                    "There are " + numcart.toString() + " item/s in your cart.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Divider(height: 1, color: Colors.grey),
                  SizedBox(height: 5),
                  Text(
                    "Total amount payable: RM " + totalPrice.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ])),
              )),
          cartList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (screenWidth / screenHeight) / 0.75,
                  children: List.generate(cartList.length, (index) {
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
                                child: SingleChildScrollView(
                                    child: Column(children: [
                                  Container(
                                      height: screenHeight / 5.5,
                                      width: screenWidth / 3.5,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "http://doubleksc.com/clothhut/images/clothesimages/${cartList[index]['image']}.jpg",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(
                                          Icons.broken_image,
                                          size: screenWidth / 2,
                                        ),
                                      )),
                                  SizedBox(height: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        cartList[index]['name'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple),
                                      ),
                                      Text(
                                        "RM " +
                                            cartList[index]['price'] +
                                            ' per piece',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "Quantity: " +
                                            cartList[index]['quantity'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "Total Price: RM " +
                                            (double.parse(cartList[index]
                                                        ['price']) *
                                                    int.parse(cartList[index]
                                                        ["quantity"]))
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_forever_sharp,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      _deleteOrderDialog(index); 
                                    },
                                  ),
                                ])])))));
                  }),
                )),
          Container(
              decoration: new BoxDecoration(
                color: Colors.pink,
              ),
              height: screenHeight / sizing,
              width: screenWidth / 0.4,
              child: Card(
                  elevation: 15,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: IconButton(
                            icon: _visible
                                ? new Icon(Icons.expand_more)
                                : new Icon(Icons.attach_money),
                            onPressed: () {
                              setState(() {
                                if (_visible) {
                                  _visible = false;
                                  sizing = 11.5;
                                } else {
                                  _visible = true;
                                  sizing = 1.5;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "TOTAL ITEM/S",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(widget.user.name +
                            ", there are " +
                            numcart.toString() +
                            " item/s in your cart"),
                        SizedBox(height: 5),
                        Divider(height: 1, color: Colors.grey),
                        SizedBox(height: 5),
                        Text(
                          "DELIVERY OPTIONS ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Pickup"),
                            new Radio(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            Text("Delivery"),
                            new Radio(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                          ],
                        ),
                        Divider(height: 2, color: Colors.grey),
                        SizedBox(height: 5),
                        Visibility(
                            visible: _stpickup,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "SELF PICKUP",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Set pickup time at ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        _timeController.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                          width: 20,
                                          child: IconButton(
                                              iconSize: 32,
                                              icon: Icon(Icons.watch),
                                              onPressed: () =>
                                                  {_selectTime(context)})),
                                    ])
                              ],
                            )),
                        SizedBox(height: 5),
                        Visibility(
                            visible: _stdeli,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: screenWidth / 2,
                                    child: Column(
                                      children: [
                                        Text(
                                          "DELIVERY ADDRESS ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Text(_homeloc),
                                        SizedBox(height: 5),
                                        GestureDetector(
                                          child: Text("Set/Change Location?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          onTap: () => {
                                            _loadMapDialog(),
                                          },
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    )),
                              ],
                            )),
                        SizedBox(height: 5),
                        Divider(height: 1, color: Colors.grey),
                        SizedBox(height: 5),
                        Text(
                          "PAYMENT ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Delivery Charge RM " +
                            delcharge.toStringAsFixed(2)),
                        Text("Clothes's price RM:" +
                            totalPrice.toStringAsFixed(2)),
                        Text("Total amount payable RM " +
                            payable.toStringAsFixed(2)),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          height: 30,
                          child: Text('Make Payment'),
                          color: Colors.red,
                          textColor: Colors.white,
                          elevation: 10,
                          onPressed: () => {
                            _makePaymentDialog(),
                          },
                        ),
                      ],
                    ),
                  ))),
        ],
      ),
    ));
  }

  void _loadCart() {
    http.post("http://doubleksc.com/clothhut/php/load_cart.php", body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "no data") {
        cartList = null;
        setState(() {
          titlecenter = "No Item Found";
        });
      } else {
        totalPrice = 0;
        numcart = 0;
        setState(() {
          var jsondata = json.decode(res.body);
          cartList = jsondata["cart"];
          for (int i = 0; i < cartList.length; i++) {
            totalPrice = totalPrice +
                double.parse(cartList[i]['price']) *
                    double.parse(cartList[i]['quantity']);
            numcart = numcart + int.parse(cartList[i]['quantity']);
          }
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteOrderDialog(int index) {
    print("Delete " + cartList[index]['name']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: new Text(
            "Delete Order " + cartList[index]['name'] + "?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are You Sure?",
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
                _deleteCart(index);
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

  void _deleteCart(int index) {
    http.post("http://doubleksc.com/clothhut/php/delete_cart.php", body: {
      "email": widget.user.email,
      "id": cartList[index]['id'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Delete Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        _loadCart();
      } else {
        Toast.show(
          "Delete Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _delivery = "Pickup";
          _stpickup = true;
          _stdeli = false;
          _calculatePayment();
          break;
        case 1:
          _delivery = "Delivery";
          _stpickup = false;
          _stdeli = true;
          _getLocation();
          break;
      }
      print(_delivery);
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
    String _hour, _minute, _time;
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  _loadMapDialog() {
    _controller = null;
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Current location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 16,
      );
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              var alheight = MediaQuery.of(context).size.height;
              var alwidth = MediaQuery.of(context).size.width;
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      backgroundColor: Colors.amber,
                  title: Center(
                    child: Text("Select New Delivery Location",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          _homeloc,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        Container(
                          height: alheight - 300,
                          width: alwidth - 10,
                          child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: _userpos,
                              markers: markers.toSet(),
                              onMapCreated: (controller) {
                                _controller.complete(controller);
                              },
                              onTap: (newLatLng) {
                                _loadLoc(newLatLng, newSetState);
                              }),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          height: 30,
                          child: Text('Close'),
                          color: Colors.red,
                          textColor: Colors.white,
                          elevation: 10,
                          onPressed: () => {
                            markers.clear(),
                            Navigator.of(context).pop(false),
                          },
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 16,
      );
      markers.add(Marker(
        markerId: markerId1,
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          title: 'New Location',
          snippet: 'New Delivery Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    _newhomeLocation();
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      _homeloc = first.addressLine;
      if (_homeloc != null) {
        latitude = lat;
        longitude = lng;
        _calculatePayment();
        return;
      }
    });
    setState(() {
      _homeloc = first.addressLine;
      if (_homeloc != null) {
        latitude = lat;
        longitude = lng;
        _calculatePayment();
        return;
      }
    });
  }

  Future<void> _getLocation() async {
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) async {
        _currentPosition = position;
        if (_currentPosition != null) {
          final coordinates = new Coordinates(
              _currentPosition.latitude, _currentPosition.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          setState(() {
            var first = addresses.first;
            _homeloc = first.addressLine;
            if (_homeloc != null) {
              latitude = _currentPosition.latitude;
              longitude = _currentPosition.longitude;
              _calculatePayment();
              return;
            }
          });
        }
      }).catchError((e) {
        print(e);
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  _makePaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.amber,
        title: new Text(
          'Proceed with payment?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
        ),
        content: new Text(
          'Are you sure to pay RM ' + payable.toStringAsFixed(2) + "?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePayment();
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _makePayment() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BillScreen(
                  user: widget.user,
                  val: payable.toStringAsFixed(2),
                )));
    _calculatePayment();
    _loadCart();
  }

  _calculatePayment() {
    setState(() {
      if (_delivery == "Pickup") {
        delcharge = 0;
        payable = totalPrice + delcharge;
      } else {
        delcharge = payable * 0.03;
        payable = totalPrice + delcharge;
      }
    });
  }

  _loadClothesDetail(int index) async {
    Clothes curclothes = new Clothes(
        id: cartList[index]['id'],
        name: cartList[index]['name'],
        price: cartList[index]['price'],
        quantity: cartList[index]['quantity'],
        image: cartList[index]['image'],
        rating: cartList[index]['rating']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ClothesDetail(
                  clothes: curclothes,
                  user: widget.user,
                )));
    _loadCart();
  }
}
