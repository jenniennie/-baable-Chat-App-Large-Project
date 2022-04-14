import 'package:baable/utils/getAPI.dart';
import 'package:baable/routes/routes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class registerPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<registerPage> {
  String firstname = '',
      lastname = '',
      loginName = '',
      password = '',
      email = '',
      message = "",
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
                Text('$message',
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
                  newMessageText = "";
                  changeText() {
                    setState(() {
                      message = newMessageText;
                    });
                  }

                  String payload = '{"firstname":"' +
                      firstname.trim() +
                      '","lastname":"' +
                      lastname.trim() +
                      '","login":"' +
                      loginName.trim() +
                      '","password":"' +
                      password.trim() +
                      '","email":"' +
                      email.trim() +
                      '"}';

                  var jsonObject;
                  try {
                    String url = 'https://large21.herokuapp.com/api/register';
                    String ret = await getAPI.getJson(url, payload);
                    jsonObject = json.decode(ret);
                  } catch (e) {
                    newMessageText = jsonObject["error"];
                    changeText();
                    return;
                  }
                  Navigator.pushNamed(context, '/login');
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
