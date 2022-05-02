import 'package:baable/utils/getAPI.dart';
import 'package:baable/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:baable/models/userDataMod.dart';
import 'dart:convert';

class accountPage extends StatefulWidget {
  @override
  accountState createState() => accountState();
}

class accountState extends State<accountPage> {
  String message = '', newMessageText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Account Settings'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.blue.withOpacity(0.3),
          elevation: 0.0,
        ),
        body: SafeArea(
            child: Column(children: [
          SizedBox(
            height: 15,
          ),
          CircleAvatar(
            //backgroundImage: NetworkImage(widget.imageUrl),
            maxRadius: 50,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            GlobalData.firstName + " " + GlobalData.lastName,
          ),
          SizedBox(
              height: 400,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    title: const Text('Username'),
                    onTap: () {
                      Navigator.pushNamed(context, '/changeUsername');
                    },
                    trailing: Text(GlobalData.loginName),
                  ),
                  ListTile(
                    title: const Text('Password'),
                    onTap: () {
                      Navigator.pushNamed(context, '/changePassword');
                    },
                  ),
                  ListTile(
                    title: const Text('Delete Account'),
                    onTap: () {
                      showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text('Delete Account'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const <Widget>[
                                      Text(
                                          'Are you sure you want to delete this account?'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete Account'),
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
                                      };

                                      var js = jsonEncoder.convert(obj);
                                      var jsonObject;
                                      var token = '';

                                      try {
                                        String url =
                                            'https://large21.herokuapp.com/api/deleteAccount';
                                        String ret =
                                            await getAPI.getJson(url, js);
                                        jsonObject = json.decode(ret);

                                        Navigator.pushNamed(context, '/login');
                                      } catch (e) {
                                        newMessageText = jsonObject["error"];
                                        changeText();
                                      }
                                    },
                                  ),
                                ]);
                          });
                    },
                  ),
                  ListTile(
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                ],
              ))
        ])));
  }
}
