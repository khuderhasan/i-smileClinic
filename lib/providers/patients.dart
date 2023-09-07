import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:i_smile_clinic/models/helper/medical_report_helper.dart';
import 'package:i_smile_clinic/models/helper/patient_helper.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../core/constatnts.dart';
import '../models/http_exeption.dart';
import '../models/medical_report.dart';
import '../models/patient.dart';
import '../models/session.dart';

class Patients with ChangeNotifier {
  List<Patient> _patients = [];

  List<Patient> get patients {
    return [..._patients];
  }

  final String authToken;
  final String userId;

  Patients(this._patients, this.authToken, this.userId);

  Future<void> getAllPatients([String? doctorId]) async {
    String? filteringSegment = (doctorId == null || doctorId == '0')
        ? ':filter_by_doctor_id'
        : doctorId;
    final url = Uri.parse('$baseUrl/assistant/patients/$filteringSegment');
    final headers = {
      'Auth-Token': authToken,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.get(url, headers: headers);
    final body = response.body;
    final json = jsonDecode(body);
    if (json['data'] == null) {
      _patients = [];
      notifyListeners();
    }
    final data = json['data'] as List<dynamic>;
    final loadedPatients = data.map((e) {
      return Patient.fromMap(e);
    }).toList();
    _patients = loadedPatients;
    notifyListeners();
  }

  //! Add the full_name to the patient info
  Future<Patient> getPatientById(int? patientId) async {
    final url = Uri.parse("$baseUrl/assistant/$patientId/");
    final headers = {
      'Auth-Token': authToken,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.get(url, headers: headers);
    // print(response.body);
    final json = jsonDecode(response.body);
    final data = json["data"]["patient"] as Map<String, dynamic>;
    Patient fetchedPatient = Patient.fromMap(data);
    return fetchedPatient;
  }

  Future<MedicalReport> getMedicalReportById(int? id) async {
    final url = Uri.parse("$baseUrl/assistant/$id/");
    final headers = {
      'Auth-Token': authToken,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.get(url, headers: headers);
    final json = jsonDecode(response.body);
    final data = json['data']['medical-report'] as Map<String, dynamic>;
    MedicalReport fetchedReport = MedicalReport.fromMap(data);

    return fetchedReport;
  }

  Future<void> addPatient(
      Patient patient, MedicalReport medicalReport, Session session) async {
    final url = Uri.parse('$baseUrl/assistant/add-patient');
    final headers = {
      'Auth-Token': authToken,
    };
    http.MultipartRequest request = http.MultipartRequest('POST', url);

    if (patient.baseImage != "") {
      // print(patient.baseImage);
      // print('trying to send the image');
      request.files.add(
        await http.MultipartFile.fromPath('profile_image', patient.baseImage!),
      );
    }
    request.fields.addAll({
      "card_id": patient.cardId.toString(),
      "first_name": patient.firstName.toString(),
      "last_name": patient.lastName.toString(),
      "email": patient.email.toString(),
      "phone": patient.phone.toString(),
      "address": patient.address.toString(),
      "full_name": patient.doctorName.toString(),
      "age": medicalReport.age.toString(),
      "gender": medicalReport.gender.toString(),
      "blood_group": medicalReport.bloodGroup.toString(),
      "blood_disorder": medicalReport.bloodDisorder.toString(),
      "alergies": medicalReport.allergies.toString(),
      "diabetes": medicalReport.diabetes.toString(),
      "medications": medicalReport.medications.toString(),
      "session_date": DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(session.sessionDate!)
          .toString(),
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final body = jsonDecode(responseBody) as Map<dynamic, dynamic>;
    // print(responseBody);
    // if (jsonDecode(response.body)['code'] == 403) {
    //   throw HttpException(jsonDecode(response.body)['exception']);
    // }
    // if (jsonDecode(response.body)['code'] == 500) {
    //   throw HttpException(jsonDecode(response.body)['error']);
    // }

    if (body["code"] == 403) {
      final error = _mapSqlErrors(body["exception"]);
      throw HttpException(error.toString());
    }
    if (body["code"] == 500) {
      throw HttpException(body["error"]);
    }
  }

  Future<void> editTimeConstraints(
      //! cancelTime == bloc modification time, maxTime ==  time per patient , minTime == bloc session completion
      String blocModificationTime,
      String timePerPatient,
      String blocSessionCompletion) async {
    final headers = {
      'Auth-Token': authToken,
    };
    final url1 = Uri.parse('$baseUrl/doctor/account/time-per-patient');
    final url2 =
        Uri.parse('$baseUrl/doctor/account/blocked-session-completion');
    final url3 = Uri.parse('$baseUrl/doctor/account/blocked-modification-time');
    try {
      // ignore: unused_local_variable
      final response = await http.post(url1,
          body: {
            'time': timePerPatient,
            'doctor_id': userId,
          },
          headers: headers);
      print('response 1 : ${response.body}');
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
    } catch (exception) {
      print('exception 1 : $exception');
      rethrow;
    }

    try {
      // ignore: unused_local_variable
      final response2 = await http.post(url2,
          body: {
            'time': blocSessionCompletion,
            'doctor_id': userId,
          },
          headers: headers);
      print('response 2 : ${response2.body}');
      final responseData = jsonDecode(response2.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
    } catch (exception) {
      print('exception 2 : $exception');
      rethrow;
    }

    try {
      // ignore: unused_local_variable
      final response3 = await http.post(url3,
          body: {
            'time': blocModificationTime,
            'doctor_id': userId,
          },
          headers: headers);
      print('response 3 : ${response3.body}');
      final responseData = jsonDecode(response3.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
    } catch (exception) {
      print('exception 3 : $exception');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTimeConstraints() async {
    final url = Uri.parse('$baseUrl/doctor/account/get-time');
    final headers = {
      'Auth-Token': authToken,
    };
    try {
      final response = await http.get(url, headers: headers);
      final responseData = jsonDecode(response.body);
      final constraints = {
        'maxTime': responseData["data"][0]["TPP"],
        'minTime': responseData["data"][1]["BSC"],
        'cancelTime': responseData["data"][2]["BMT"],
      };
      // print("Get Time Function Data : $responseData");
      return constraints;
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> deletePatient(int? patientId) async {
    final url = Uri.parse("$baseUrl/assistant/patients/$patientId/remove");
    final headers = {
      'Auth-Token': authToken,
      'Accept': 'application/json',
    };
    try {
      final response = await http.post(url, headers: headers);
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> updatePersonalInfo(PatientHelper patient, int patientId) async {
    final url = Uri.parse('$baseUrl/assistant/patients/$patientId/update-data');
    final headers = {
      'Auth-Token': authToken,
      'Accept': 'application/json',
    };
    try {
      final response = await http.post(url,
          body: {
            'card_id': patient.cardId.toString(),
            'first_name': patient.firstName,
            'last_name': patient.lastName,
            'email': patient.email,
            'phone': '0${patient.phone.toString()}',
            'address': patient.address,
          },
          headers: headers);
      final responseData = jsonDecode(response.body);
      print(responseData);
      if (responseData['errors'] != null) {
        throw HttpException(responseData['errors'].toString());
      }
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> updateMedicalInfo(
      MedicalReportHelper medicalReport, int patientId) async {
    final url = Uri.parse(
        '$baseUrl/assistant/patients/$patientId/medical-report/modify');
    final headers = {
      'Auth-Token': authToken,
      'Accept': 'application/json',
    };
    try {
      final response = await http.post(url,
          body: {
            'age': medicalReport.age.toString(),
            'gender': medicalReport.gender,
            'blood_group': medicalReport.bloodGroup,
            'blood_disorder': medicalReport.bloodDisorder,
            'alergies': medicalReport.allergies,
            'diabetes': medicalReport.diabetes,
            'medications': medicalReport.medications
          },
          headers: headers);
      final responseData = jsonDecode(response.body);
      if (responseData['exceptions'] != null) {
        throw HttpException(responseData['errors'].toString());
      }
    } catch (exception) {
      rethrow;
    }
  }
}

String _mapSqlErrors(String error) {
  print("map error is working");
  if (error.contains("for key 'email' ")) {
    return "This Email is used for a patient before";
  } else if (error.contains("for key 'phone' ")) {
    return "This Phone number is used for a patient before";
  } else if (error.contains("for key 'card_id' ")) {
    return "This Card id is used for a patient before";
  }
  return error;
}
