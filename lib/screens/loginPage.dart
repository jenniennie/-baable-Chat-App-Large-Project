import 'package:baable/utils/getAPI.dart';
import 'package:baable/routes/routes.dart';
import 'package:baable/models/userDataMod.dart';
import 'package:flutter/material.dart';
import 'package:baable/theme/defaultTheme.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  String loginName = '', password = '', message = '', newMessageText = '';

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 150, 0, 30),
        child: Column(
          children: <Widget>[
            //Image.asset('assets/images/cloud.png'),
            SizedBox(
                height: 80,
                child: const Text(
                  'baable',
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Slabo27px'),
                )),
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/cloud.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Center(
                        child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Slabo27px'),
                            )),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          message,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    Container(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        onChanged: (text) {
                          loginName = text;
                        },
                        decoration: InputDecoration(
                          enabledBorder: new OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          labelText: 'Username',
                          labelStyle:
                              TextStyle(fontSize: 15.0, color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        onChanged: (text) {
                          password = text;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            enabledBorder: new OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(fontSize: 15.0, color: Colors.black)),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/resetpassword');
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 20, 135, 36),
                          borderRadius: BorderRadius.circular(20)),
                      child: FlatButton(
                        onPressed: () async {
                          newMessageText = "";
                          changeText() {
                            setState(() {
                              message = newMessageText;
                            });
                          }

                          final jsonEncoder = JsonEncoder();

                          var obj = {
                            "login": loginName.trim(),
                            "password": password.trim(),
                          };

                          var js = jsonEncoder.convert(obj);
                          var jsonObject;
                          String firName = '';

                          try {
                            String url =
                                'https://large21.herokuapp.com/api/login';
                            String ret = await getAPI.getJson(url, js);
                            jsonObject = json.decode(ret);
                            firName = jsonObject["firstname"];
                          } catch (e) {
                            newMessageText = jsonObject["error"];
                            changeText();
                          }
                          if (firName == '') {
                            newMessageText = "Incorrect Username/Password";
                            changeText();
                          } else {
                            changeText();
                            GlobalData.firstName = jsonObject["firstname"];
                            GlobalData.lastName = jsonObject["lastname"];
                            GlobalData.loginName = loginName;
                            GlobalData.password = password;
                            GlobalData.email = jsonObject["email"];
                            var verific = jsonObject["verification"];
                            var email = jsonObject["email"];
                            if (verific == false)
                              Navigator.pushNamed(context, '/verify',
                                  arguments: {
                                    "email": email,
                                  });
                            else
                              Navigator.pushNamed(context, '/chat');
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    SizedBox(height: 70),
                  ],
                )),
            SizedBox(
                height: 80,
                child: TextButton(
                  child: Text("New User? Create Account",
                      style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                )),
          ],
        ),
      ),
    );
  }
}
