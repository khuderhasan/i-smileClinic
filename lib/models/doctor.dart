import 'package:flutter/material.dart';

class Doctor with ChangeNotifier {
  final int id;
  final String fullName;

  Doctor({required this.id, required this.fullName});

  factory Doctor.fromMap(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      fullName: json['full_name'],
    );
  }
}
