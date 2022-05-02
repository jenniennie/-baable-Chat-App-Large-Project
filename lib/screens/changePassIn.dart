import 'package:baable/models/userDataMod.dart';
import 'package:baable/utils/getAPI.dart';
import 'package:baable/routes/routes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class changePass extends StatefulWidget {
  @override
  _ChangePass createState() => _ChangePass();
}

class _ChangePass extends State<changePass> {
  String newPassword = '', oldPassword = '', message = '', newMessageText = '';

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
                      'Change Password',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      'Pleasr enter your current password and your new password',
                      style: TextStyle(fontSize: 15),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: TextField(
                onChanged: (text) {
                  oldPassword = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Old Password',
                    hintText: 'Old Password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: TextField(
                onChanged: (text) {
                  newPassword = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Password',
                    hintText: 'New Password'),
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
                    "password": oldPassword.trim(),
                    "newPassword": newPassword.trim(),
                  };

                  var js = jsonEncoder.convert(obj);
                  var jsonObject;
                  var token = '';

                  try {
                    String url =
                        'https://large21.herokuapp.com/api/changePasswordInside';
                    String ret = await getAPI.getJson(url, js);
                    jsonObject = json.decode(ret);

                    Navigator.pushNamed(context, '/profile');
                  } catch (e) {
                    newMessageText = jsonObject["error"];
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
