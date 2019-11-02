import 'package:intelliTAG/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intelliTAG/utility/InheritedInfo.dart';
import 'package:intelliTAG/screens/authentication/authentication_screen.dart';

void main() {
  runApp(StateContainer(
    
    child: new MaterialApp(
      home: new AuthenticationScreen(),
    ),
  ));
}
