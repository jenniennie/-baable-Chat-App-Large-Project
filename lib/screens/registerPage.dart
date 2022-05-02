import 'package:baable/utils/getAPI.dart';
import 'package:baable/routes/routes.dart';
import 'package:baable/models/userDataMod.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class registerPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<registerPage> {
  String firstname = '',
      lastname = '',
      login = '',
      password = '',
      email = '',
      message = '',
      newMessageText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(''),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blue.withOpacity(0.3),
        elevation: 0.0,
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
                      'Register',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ),
            Column(
              children: <Widget>[
                Text(message,
                    style: TextStyle(fontSize: 14, color: Colors.black)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                onChanged: (text) {
                  firstname = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                    hintText: 'First Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                onChanged: (text) {
                  lastname = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                    hintText: 'Last Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                onChanged: (text) {
                  email = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                onChanged: (text) {
                  login = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
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
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  newMessageText = '';
                  changeText() {
                    setState(() {
                      message = newMessageText;
                    });
                  }

                  /*String payload = '{"firstname":"' +
                      firstname.trim() +
                      '","lastname":"' +
                      lastname.trim() +
                      '","login":"' +
                      login.trim() +
                      '","password":"' +
                      password.trim() +
                      '","email":"' +
                      email.trim() +
                      '"}';
*/
                  final jsonEncoder = JsonEncoder();
                  var jsonObject;
                  var obj = {
                    "firstname": firstname.trim(),
                    "lastname": lastname.trim(),
                    "login": login.trim(),
                    "password": password.trim(),
                    "email": email.trim(),
                  };
                  var verification;
                  var js = jsonEncoder.convert(obj);
                  try {
                    String url = 'https://large21.herokuapp.com/api/register';
                    String ret = await getAPI.getJson(url, js);
                    jsonObject = json.decode(ret);
                    GlobalData.firstName = firstname.trim();
                    GlobalData.lastName = lastname.trim();
                    GlobalData.loginName = jsonObject["login"];
                    GlobalData.password = jsonObject["password"];
                    GlobalData.email = jsonObject["email"];
                    verification = jsonObject["verification"];
                    changeText();
                  } catch (e) {
                    newMessageText = jsonObject["error"];
                    changeText();
                  }
                  if (verification == false && jsonObject["error"] == "")
                    Navigator.pushNamed(context, '/verify', arguments: {
                      "email": email.trim(),
                    });
                  else if (jsonObject["error"] == "")
                    Navigator.pushNamed(context, '/login');
                  else {
                    newMessageText = jsonObject["error"];
                    changeText();
                  }
                },
                child: Text(
                  'Create Account',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
