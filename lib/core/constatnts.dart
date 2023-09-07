import 'package:flutter/material.dart';

const String baseUrl = 'http://192.168.43.23:8000';

const myBlue = Color(0xff0177B6);
const groupList = [
  DropdownMenuItem(
    value: 'A+',
    child: Text('A+'),
  ),
  DropdownMenuItem(
    value: 'A-',
    child: Text('A-'),
  ),
  DropdownMenuItem(
    value: 'B+',
    child: Text('B+'),
  ),
  DropdownMenuItem(
    value: 'B-',
    child: Text('B-'),
  ),
  DropdownMenuItem(
    value: 'AB+',
    child: Text('AB+'),
  ),
  DropdownMenuItem(
    value: 'AB-',
    child: Text('AB-'),
  ),
  DropdownMenuItem(
    value: 'O+',
    child: Text('O+'),
  ),
  DropdownMenuItem(
    value: 'O-',
    child: Text('O-'),
  ),
];
const gernderList = [
  DropdownMenuItem(
    value: 'male',
    child: Text('Male'),
  ),
  DropdownMenuItem(
    value: 'female',
    child: Text('Female'),
  ),
];
List<Map<String, dynamic>> languages = [
  {"code": "en", "name": "English"},
  {"code": "ar", "name": "العربية"},
];

enum BottomSheetKind { Add, Reschedual }

ThemeData myTheme = ThemeData(
  primarySwatch: const MaterialColor(0xff0177B6, {
    50: Color(0xffE3F2FD),
    100: Color(0xffBBDEFB),
    200: Color(0xff90CAF9),
    300: Color(0xff64B5F6),
    400: Color(0xff42A5F5),
    500: Color(0xff0177B6),
    600: Color(0xff1E88E5),
    700: Color(0xff1976D2),
    800: Color(0xff1565C0),
    900: Color(0xff0D47A1),
  }),
  fontFamily: 'Lato',
);
