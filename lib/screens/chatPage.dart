import 'package:flutter/material.dart';
import 'package:baable/models/chatListMod.dart';
import 'package:baable/widgets/conversationList.dart';
import 'package:baable/models/userDataMod.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:location_permissions/location_permissions.dart';
import 'package:location/location.dart';
import 'package:baable/utils/getAPI.dart';
//import 'package:permission_handler/permission_handler.dart' as perm;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

List<ChatUsers> chatUsers = [];
String latitude_data = '';
String longitude_data = '';
String newMessageText = '';
late bool _serviceEnabled;
final jsonEncoder = JsonEncoder();

Future _getLocation() async {
  Location location = new Location();

  var _permissionGranted = await location.hasPermission();
  _serviceEnabled = await location.serviceEnabled();
  print(_serviceEnabled);
  if (_permissionGranted != PermissionStatus.granted || !_serviceEnabled) {
    ///asks permission and enable location dialogs
    _permissionGranted = await location.requestPermission();
    _serviceEnabled = await location.requestService();
  } else {
    print('no request needed');
  }

  LocationData _currentPosition = await location.getLocation();

  longitude_data = _currentPosition.longitude.toString();
  latitude_data = _currentPosition.latitude.toString();
  findRoom();
}

void findRoom() async {
  var obj = {
    "latitude": latitude_data,
    "longitude": longitude_data,
  };
  var js = jsonEncoder.convert(obj);
  var jsonObject;
  var roomname;
  try {
    String url = 'https://large21.herokuapp.com/api/check-geofence';
    String ret = await getAPI.getJson(url, js);
    jsonObject = json.decode(ret);
    roomname = jsonObject["name"];
    chatUsers.add(ChatUsers(SenderId: roomname));
  } catch (e) {
    newMessageText = jsonObject["error"];
    print('new message $newMessageText');
  }
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*_getCurrentLocation() {
      print('goeshere');
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
              forceAndroidLocationManager: true)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
        });
      }).catchError((e) {
        print(e);
      });
    }*/

    //_getCurrentLocation();

    //print('$_currentPosition.latitude');

    //print('LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}');
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Image.asset('assets/images/cloud.png', height: 32),
        centerTitle: true,

        /* title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cloud.png',
              fit: BoxFit.contain,
              height: 32,
            ),
          ],
        ),
        //centerTitle: true,*/
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  SenderId: chatUsers[index].SenderId,
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/lilshep.png'),
                    maxRadius: 50,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    GlobalData.firstName + " " + GlobalData.lastName,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 64, 155, 79),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateState() {}
}
