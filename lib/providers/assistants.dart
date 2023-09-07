import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:i_smile_clinic/core/constatnts.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Assistants with ChangeNotifier {
  String authToken;

  Assistants(
    this.authToken,
  );

  Future<void> addAssistant(String email, String password) async {
    final url = Uri.parse('$baseUrl/doctor/assistant/add-assistant');
    final headers = {
      'Auth-Token': authToken,
    };
    try {
      final response = await http.post(url,
          body: {
            'email': email,
            'password': password,
          },
          headers: headers);
      print(response.body);
    } catch (exception) {
      print(exception);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAssistants() async {
    final url = Uri.parse('$baseUrl/doctor/assistant/');
    final headers = {
      'Auth-Token': authToken,
    };
    try {
      final response = await http.get(url, headers: headers);
      final responseData = json.decode(response.body);
      print(responseData);
      return responseData;
    } catch (excepitn) {
      rethrow;
    }
  }

  Future<void> deleteAssistant(int? id) async {
    final url = Uri.parse('$baseUrl/doctor/assistant/$id/remove');
    final headers = {
      'Auth-Token': authToken,
    };
    try {
      await http.post(url, headers: headers);
    } catch (exception) {
      rethrow;
    }
  }
}
