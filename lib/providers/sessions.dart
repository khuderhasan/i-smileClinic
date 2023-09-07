import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../core/constatnts.dart';
import '../models/http_exeption.dart';
import '../models/session.dart';

class Sessions with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Session> _sessions = [];
  final String authToken;

  Sessions(this._sessions, this.authToken);
  List<Session> get sessions {
    return [..._sessions];
  }

  void addSession(Session session) {
    final Session newSession = Session(
      patientId: session.patientId,
      sessionId: Random().nextInt(100),
      status: session.status,
      sessionDate: session.sessionDate,
      description: session.description,
      notices: session.notices,
    );
    _sessions.add(newSession);
    notifyListeners();
  }

  // Future<void> fetchSessionsByID(int patientId) async {
  //   final url = Uri.parse('get api for the patient sessions');
  //   final response = await http.get(url);
  //   final extractData = json.decode(response.body) as Map<int, dynamic>;
  //   List<Session> loadedSessions = [];
  //   extractData.forEach((patientId, sessionData) {
  //     loadedSessions.add(Session(
  //       patientId: patientId,
  //       status: sessionData.status,
  //       sessionId: sessionData.sessionId,
  //       sessionDate: sessionData.sessionDate,
  //       description: sessionData.description,
  //       notices: sessionData.notices,
  //     ));
  //     _sessions = loadedSessions;
  //     notifyListeners();
  //   });
  // }

  Future<void> getSessionsBysUserId(int? id) async {
    final url = Uri.parse("$baseUrl/assistant/patients/$id/get-sessions");
    final headers = {
      'Auth-Token': authToken,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.get(url, headers: headers);
    final responsebody = jsonDecode(response.body);
    // print(response.body);
    return responsebody;
  }

  Future<void> addNewSession(int patientId, String date) async {
    final url = Uri.parse("$baseUrl/assistant/patients/$patientId/add-session");
    final headers = {
      'Auth-Token': authToken,
    };
    final response =
        await http.post(url, body: {"session_date": date}, headers: headers);
    if (jsonDecode(response.body)['code'] == 500) {
      throw HttpException(jsonDecode(response.body)['error']);
    }
  }

  Future<void> getSessionsForDay(String year, String month, String day,
      [String? doctorId]) async {
    String? filteringSegment = (doctorId == null || doctorId == '0')
        ? ':filter_by_doctor_id'
        : doctorId;
    final url = Uri.parse(
        '$baseUrl/assistant/schedule/day-sessions/$year/$month/$day/$filteringSegment');
    final headers = {
      'Auth-Token': authToken,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.get(url, headers: headers);
    final responsebody = jsonDecode(response.body);
    return responsebody;
  }

  //! anytime I try to modify details it says : cannot modify session that is currently in progress
  Future<void> updateSessionsDetailsAndNotes(
      String description, String notices, int patientId, int sessionId) async {
    final url = Uri.parse(
        '$baseUrl/doctor/schedule/$patientId/$sessionId/modify-details');
    final headers = {
      'Auth-Token': authToken,
      'Accept': 'application/json',
    };
    try {
      final response = await http.post(
        url,
        body: {
          'description': description,
          'notices': notices,
        },
        headers: headers,
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['code'] == 500) {
        throw HttpException(responseData["error"].toString());
      }
      if (responseData['errors'] != null) {
        throw HttpException((responseData)['errors'].toString());
      }
    } catch (exception) {
      rethrow;
    }
  }

//! couldn't check the functionality should set the system variables first.
//! should make the error handling functionality.

  Future<void> cancelSession(int? sessionId, int? patientId) async {
    final url =
        Uri.parse('$baseUrl/assistant/$patientId/cancel-session/$sessionId');
    final headers = {
      'Auth-Token': authToken,
    };
    try {
      final response = await http.post(url, headers: headers);
      // ignore: unused_local_variable
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> reschedualSession(
      int? patientId, int? sessionId, String newDate) async {
    final url =
        Uri.parse('$baseUrl/assistant/$patientId/modify-session/$sessionId');
    final headers = {
      'Auth-Token': authToken,
    };

    try {
      final respnose = await http.post(url, headers: headers, body: {
        'session_date': newDate,
      });
      // ignore: unused_local_variable
      final responseData = json.decode(respnose.body);
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> uploadImage(
      String baseImage, int patientId, String title) async {
    final url =
        Uri.parse("$baseUrl/assistant/patients/$patientId/upload-files");
    final headers = {"Auth-Token": authToken};
    try {
      http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath("file", baseImage),
      );
      request.fields.addAll({"name": title});
      request.headers.addAll(headers);
      // ignore: unused_local_variable
      http.StreamedResponse response = await request.send();
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> getAttachedFiles(int patientId) async {
    try {
      final url = Uri.parse("$baseUrl/assistant/patients/$patientId/get-files");
      final headers = {"Auth-Token": authToken};
      final response = await http.get(headers: headers, url);
      final responseBody = json.decode(response.body);
      return responseBody;
    } catch (exception) {
      rethrow;
    }
  }
}
