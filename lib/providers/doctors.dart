import 'package:flutter/material.dart';
import 'package:i_smile_clinic/models/doctor.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/constatnts.dart';

class Doctors with ChangeNotifier {
  List<Doctor> _doctors = [];

  List<Doctor> get doctors {
    return [..._doctors];
  }

  final String authToken;

  Doctors(this.authToken, this._doctors);
  Future<void> getAllDoctors() async {
    final url = Uri.parse('$baseUrl/assistant/doctors');
    final headers = {
      'Auth-Token': authToken,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.get(url, headers: headers);
    final json = jsonDecode(response.body);
    final data = json['data'] as List<dynamic>;
    final loadedDoctors = data.map((e) {
      return Doctor.fromMap(e);
    }).toList();
    _doctors = loadedDoctors;
    notifyListeners();
  }
}
