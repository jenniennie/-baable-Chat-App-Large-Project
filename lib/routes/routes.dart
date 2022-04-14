import 'package:flutter/material.dart';
import 'package:baable/screens/loginPage.dart';
import 'package:baable/screens/registerPage.dart';
import 'package:baable/screens/verifyPage.dart';
import 'package:baable/screens/chatPage.dart';

import 'package:baable/screens/resetPassPage.dart';

class Routes {
  static const String LOGINSCREEN = '/login';
  static const String REGISTERSCREEN = '/register';
  static const String VERIFYSCREEN = '/verify';
  static const String CHATLISTSCREEN = '/chat';
  //static const String CHATSCREEN = '/indivchat';
  static const String RESETPASSSCREEN = '/resetpassword';
  // routes of pages in the app
  static Map<String, Widget Function(BuildContext)> get getroutes => {
        '/': (context) => LoginScreen(),
        LOGINSCREEN: (context) => LoginScreen(),
        REGISTERSCREEN: (context) => registerPage(),
        //VERIFYSCREEN: (context) =>
        CHATLISTSCREEN: (context) => ChatPage(),
        //??CHATSCREEN: (context) =>
        //RESETPASSSCREEN: (context) =>
      };
}
