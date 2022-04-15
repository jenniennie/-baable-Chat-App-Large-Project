import 'package:baable/utils/getAPI.dart';
import 'package:baable/routes/routes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class GlobalData {
  static late String firstName;
  static late String lastName;
  static late String loginName;
  static late String password;
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  String loginName = '', password = '', message = "", newMessageText = '';

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Baable"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ),
            Column(
              children: <Widget>[
                Text('$message',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
              ],
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (text) {
                  loginName = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                onChanged: (text) {
                  password = text;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Password'),
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  newMessageText = "";
                  changeText() {
                    setState(() {
                      message = newMessageText;
                    });
                  }
/*
                  String payload = '{"login":"' +
                      loginName.trim() +
                      '","password":"' +
                      password.trim() +
                      '"}';
*/

                  final jsonEncoder = JsonEncoder();

                  var obj = {
                    "login": loginName.trim(),
                    "password": password.trim(),
                  };

                  var js = jsonEncoder.convert(obj);
                  var jsonObject;
                  String firName = '';

                  try {
                    String url = 'https://large21.herokuapp.com/api/login';
                    String ret = await getAPI.getJson(url, js);
                    jsonObject = json.decode(ret);
                    firName = jsonObject["firstname"];
                    print('HEREHER: $firName');
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
                    //Navigator.pushNamed(context, '/verify');
                    Navigator.pushNamed(context, '/chat');
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
                height: 130,
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text("New User? Create Account"),
                )),
          ],
        ),
      ),
    );
  }
}
