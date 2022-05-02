import 'package:baable/routes/routes.dart';
import 'package:baable/utils/getAPI.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:baable/screens/resetPassPage2.dart';

// ??????
class resetPassPage extends StatefulWidget {
  @override
  _resetState createState() => _resetState();
}

class _resetState extends State<resetPassPage> {
  String email = '', message = '', newMessageText = '';

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
                      'Please enter your the email associated with your account. An email will be sent with a 6-digit code.',
                      style: TextStyle(fontSize: 15),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
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
                    "email": email.trim(),
                  };

                  var js = jsonEncoder.convert(obj);
                  var jsonObject;
                  var token = '';

                  try {
                    String url =
                        'https://large21.herokuapp.com/api/recoveryPassword';
                    String ret = await getAPI.getJson(url, js);
                    jsonObject = json.decode(ret);
                    token = jsonObject["passwordtoken"];

                    Navigator.pushNamed(context, '/resetpassword2',
                        arguments: {"email": email.trim(), "token": token});
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
