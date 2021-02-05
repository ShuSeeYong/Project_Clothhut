import 'package:clothhut/mainpage.dart';
import 'package:clothhut/registerpage.dart';
import 'package:clothhut/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  final formKeyForResetEmail = GlobalKey<FormState>();
  final formKeyForResetPassword = GlobalKey<FormState>();
  TextEditingController passResetController = new TextEditingController();
  TextEditingController emailForgotController = new TextEditingController();
  String _email = "";
  String _password = "";
  bool _rememberMe = false;
  bool _passwordVisible = false;
  bool autoValidate = false;
  SharedPreferences prefs;

  @override
  void initState() {
    loadpref();
    print('Init: $_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Login',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
            ),
            resizeToAvoidBottomPadding: true,
            body: new Container(
              padding: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/logocloth.png",
                      width: 200,
                      height: 200,
                    ),
                    TextField(
                        controller: _emcontroller,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email))),
                    TextField(
                      controller: _pscontroller,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: _passwordVisible,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                        Text('Remember Me', style: TextStyle(fontSize: 17))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      minWidth: 250,
                      height: 50,
                      child: Text('Login',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      color: Colors.deepOrange,
                      textColor: Colors.black,
                      elevation: 15,
                      onPressed: _onLogin,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: _onRegister,
                        child: Text('Register New Account',
                            style: TextStyle(fontSize: 17))),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: _onForgot,
                        child: Text('Forgot Password',
                            style: TextStyle(fontSize: 17))),
                  ],
                ),
              ),
            )));
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
      savepref(value);
    });
  }

  Future<void> _onLogin() async {
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post("https://doubleksc.com/clothhut/php/login_user.php", body: {
      "email": _email,
      "password": _password,
    }).then((res) {
      print(res.body);
      List userdata = res.body.split(",");
      if (userdata[0] == "success") {
        Toast.show(
          "Login Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        User user = new User(
            email: _email,
            name: userdata[1],
            password: _password,
            phone: userdata[2],
            datereg: userdata[3]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainPage(user: user)));
      } else {
        Toast.show(
          "Login Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
  }

  void _onForgot() {
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: new BorderSide(color: Colors.grey, width: 1.5),
          ),
          title: new Text(
            "Forgot Password ?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: new Container(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Enter Your Email : ",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Form(
                        key: formKeyForResetEmail,
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email', icon: Icon(Icons.email)),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          validator: emailValidate,
                          onSaved: (String value) {
                            _email = value;
                          },
                        )),
                  ],
                ),
              )),
          actions: <Widget>[
            new FlatButton(
                child: new Text(
                  "Yes",
                  style: TextStyle(
                      color: Colors.black,fontSize:15, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (formKeyForResetEmail.currentState.validate()) {
                    _passwordVisible = false;
                    emailForgotController.text = emailController.text;
                    _enterResetPass();
                  }
                }),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                    color: Colors.black, fontSize:15,fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  void loadpref() async {
    prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';
    _rememberMe = (prefs.getBool('rememberme')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emcontroller.text = _email;
        _pscontroller.text = _password;
        _rememberMe = _rememberMe;
      });
    }
  }

  void savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;

    if (value) {
      if (_email.length < 5 && _password.length < 3) {
        print("EMAIL/PASSWORD EMPTY");
        _rememberMe = false;
        Toast.show(
          "Email/password empty!!!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('rememberme', value);
        Toast.show(
          "Account will saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        print("SUCCESS");
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('rememberme', false);
      setState(() {
        _emcontroller.text = "";
        _pscontroller.text = "";
        _rememberMe = false;
      });
      Toast.show(
        "Perferences unclick",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
    }
  }

  String emailValidate(String value) {
    if (value.isEmpty) {
      return 'Email is Required';
    }

    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return 'Please Enter a Valid Email Address!';
    }

    return null;
  }

  void _enterResetPass() {
    TextEditingController passController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.amber[200],
              title: new Text(
                "New Password",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: new Container(
                  height: 100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter Your New Password : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        Form(
                            key: formKeyForResetPassword,
                            child: TextFormField(
                                controller: passController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon: Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    child: Icon(_passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                obscureText: !_passwordVisible,
                                validator: passVisible,
                                onSaved: (String value) {
                                  _password = value;
                                }))
                      ],
                    ),
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                          color: Colors.black, fontSize:15,fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (formKeyForResetPassword.currentState.validate()) {
                        passResetController.text = passController.text;
                        _resetPass();
                      }
                    }),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                        color: Colors.black, fontSize:15,fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  String passVisible(String value) {
    if (value.isEmpty) {
      return 'Password is Required';
    }

    if (value.length < 5) {
      return 'Password Length Must Be 5 Digits Above';
    }
    return null;
  }

  void _resetPass() {
    String email = emailForgotController.text;
    String password = passResetController.text;

    final form = formKeyForResetPassword.currentState;

    if (form.validate()) {
      form.save();
      http.post("https://doubleksc.com/clothhut/php/reset_password.php", body: {
        "email": email,
        "password": password,
      }).then((res) {
        print(res.body);
        if (res.body.contains("success")) {
          Navigator.of(context).pop();
          Toast.show("Reset Password Success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        } else {
          Toast.show("Reset Password Failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }
}
