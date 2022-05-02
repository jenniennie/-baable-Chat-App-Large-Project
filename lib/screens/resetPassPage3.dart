import 'package:baable/routes/routes.dart';
import 'package:baable/utils/getAPI.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class resetPassPage3 extends StatefulWidget {
  final String email;
  final String token;
  resetPassPage3({required this.email, required this.token});

  @override
  resetPassPageState createState() => resetPassPageState();
}

class resetPassPageState extends State<resetPassPage3> {
  @override
  String message = '', newMessageText = '', newPassword = '';

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
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
                      'Reset Password',
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
                      'Please enter your new password.',
                      style: TextStyle(fontSize: 15),
                    )),
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
                    "passwordtoken": arguments['token'].trim(),
                    "email": arguments['email'].trim(),
                    "newpassword": newPassword.trim(),
                  };

                  var js = jsonEncoder.convert(obj);
                  var jsonObject;
                  try {
                    String url =
                        'https://large21.herokuapp.com/api/passwordChange';
                    String ret = await getAPI.getJson(url, js);
                    jsonObject = json.decode(ret);
                    var retCheck = jsonObject["newpassword"];
                    if (retCheck == newPassword.trim())
                      Navigator.pushNamed(context, '/login');
                  } catch (e) {
                    newMessageText = jsonObject["error"];
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
