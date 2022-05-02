import 'package:baable/routes/routes.dart';
import 'package:baable/utils/getAPI.dart';
import 'package:baable/models/userDataMod.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class changeUser extends StatefulWidget {
  @override
  _resetState createState() => _resetState();
}

class _resetState extends State<changeUser> {
  String newLogin = '', message = '', newMessageText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(''),
        backgroundColor:
            Colors.blue.withOpacity(0.3), //You can make this transparent
        elevation: 0.0, //No shadow
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
                      'Change Username',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Please enter your new username.',
                      style: TextStyle(fontSize: 15),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: TextField(
                onChanged: (text) {
                  newLogin = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Username',
                    hintText: 'New Username'),
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

                  final jsonEncoder = JsonEncoder();

                  var obj = {
                    "login": GlobalData.loginName.trim(),
                    "password": GlobalData.password.trim(),
                    "newLogin": newLogin.trim(),
                  };

                  var js = jsonEncoder.convert(obj);
                  var jsonObject;
                  var retcheck = '';

                  try {
                    String url =
                        'https://large21.herokuapp.com/api/changeUsername';
                    String ret = await getAPI.getJson(url, js);
                    jsonObject = json.decode(ret);
                    retcheck = jsonObject["newLogin"];
                    GlobalData.loginName = jsonObject["newLogin"];
                    if (GlobalData.loginName == newLogin.trim()) {
                      Navigator.pushNamed(context, '/profile');
                    }
                  } catch (e) {
                    print('catche'); //newMessageText = jsonObject["error"];
                    changeText();
                  }
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
