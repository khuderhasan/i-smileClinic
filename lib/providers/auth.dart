import 'dart:convert';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:i_smile_clinic/core/constatnts.dart';

import '../models/http_exeption.dart';

enum UserType { Doctor, Assistant }

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  // ignore: unused_field
  UserType? _userType;

  bool get isAuth {
    return (_token != null);
  }

  UserType? get userTyper {
    return _userType;
  }

  String get token {
    return _token ?? '';
  }

  String get userId {
    return _userId!;
  }

  Future<void> signUp(String email, String password, String fullName) async {
    final url = Uri.parse('$baseUrl/api/signup');

    try {
      final response = await http.post(url, body: {
        'email': email.toString(),
        'password': password.toString(),
        'full_name': fullName.toString(),
      });
      final responseData = jsonDecode(response.body);
      // print(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
      _token = responseData["data"]["token"];
      _userId = responseData["data"]["doctor"]["id"].toString();
      _userType = (responseData["data"]["doctor"]["is_doctor"] == 1)
          ? UserType.Doctor
          : UserType.Assistant;

      notifyListeners();
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/login');

    try {
      final response = await http.post(url, body: {
        'email': email.toString(),
        'password': password,
      });
      final responseData = jsonDecode(response.body);
      // print(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
      _token = responseData['data']['token'];
      _userId = responseData['data']['user']['id'].toString();

      _userType = (int.parse(responseData["data"]["user"]["is_doctor"]) == 1)
          ? UserType.Doctor
          : UserType.Assistant;
      notifyListeners();
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    _userId = '';
    _token = null;
    _userType = null;
    notifyListeners();
  }
}
