import 'package:baable/routes/routes.dart';
import 'package:baable/utils/getAPI.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class verifyPage extends StatefulWidget {
  final String email;
  verifyPage({required this.email});
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<verifyPage> {
  String verificationCode = '', message = '', newMessageText = '';

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(''), // You can add title here
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
                      'Verify',
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
                      'Please enter the 6-digit verification code sent in the email associated with your account',
                      style: TextStyle(fontSize: 15),
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
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: TextField(
                onChanged: (text) {
                  verificationCode = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Verification Code',
                    hintText: 'Verification Code'),
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
                    "token": verificationCode.trim(),
                    "email": arguments['email'].trim(),
                  };

                  var js = jsonEncoder.convert(obj);
                  var jsonObject;
                  var veri = '';

                  try {
                    String url =
                        'https://large21.herokuapp.com/api/verification';
                    String ret = await getAPI.getJson(url, js);
                    jsonObject = json.decode(ret);
                  } catch (e) {
                    newMessageText = jsonObject["error"];
                  }
                  if (veri == false) {
                    newMessageText = "Incorrect Code";
                    changeText();
                  } else {
                    Navigator.pushNamed(context, '/chat');
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
