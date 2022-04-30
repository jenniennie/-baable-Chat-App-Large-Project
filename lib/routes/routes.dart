import 'package:baable/screens/indivChat.dart';
import 'package:flutter/material.dart';
import 'package:baable/screens/loginPage.dart';
import 'package:baable/screens/registerPage.dart';
import 'package:baable/screens/verifyPage.dart';
import 'package:baable/screens/chatPage.dart';
import 'package:baable/screens/indivChat.dart';
import 'package:baable/screens/resetPassPage.dart';
import 'package:baable/screens/resetPassPage2.dart';
import 'package:baable/screens/resetPassPage3.dart';

class Routes {
  static const String LOGINSCREEN = '/login';
  static const String REGISTERSCREEN = '/register';
  static const String VERIFYSCREEN = '/verify';
  static const String CHATLISTSCREEN = '/chat';
  //static const String CHATSCREEN = '/indivchat';
  static const String RESETPASSSCREEN = '/resetpassword';
  static const String RESETPASSSCREEN2 = '/resetpassword2';
  static const String RESETPASSSCREEN3 = '/resetpassword3';
  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
        '/': (context) => LoginScreen(),
        LOGINSCREEN: (context) => LoginScreen(),
        REGISTERSCREEN: (context) => registerPage(),
        VERIFYSCREEN: (context) => verifyPage(email: ''),
        CHATLISTSCREEN: (context) => ChatPage(),
        //CHATSCREEN: (context) => indivChat(),
        RESETPASSSCREEN: (context) => resetPassPage(),
        RESETPASSSCREEN2: (context) => resetPassPage2(email: '', token: ''),
        RESETPASSSCREEN3: (context) => resetPassPage3(email: '', token: ''),
      };
}
