import 'package:baable/routes/routes.dart';
import 'package:baable/utils/getAPI.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class resetPassPage2 extends StatefulWidget {
  final String email;
  final String token;
  resetPassPage2({required this.email, required this.token});

  @override
  resetPassPageState createState() => resetPassPageState();
}

class resetPassPageState extends State<resetPassPage2> {
  String message = '', newMessageText = '', passCode = '';

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
                      'Please enter the 6-digit code sent to the email associated with your account.',
                      style: TextStyle(fontSize: 15),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: TextField(
                onChanged: (text) {
                  passCode = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '6-digit Code',
                    hintText: '6-digit Code'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  changeText() {
                    setState(() {
                      message = newMessageText;
                    });
                  }

                  final jsonEncoder = JsonEncoder();

                  if (arguments['token'] == passCode.trim()) {
                    Navigator.pushNamed(context, '/resetpassword3', arguments: {
                      "email": arguments['email'],
                      "token": passCode.trim()
                    });
                  } else {
                    changeText() {
                      setState(() {
                        message = "Incorrect code. Please try again.";
                      });
                    }
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
