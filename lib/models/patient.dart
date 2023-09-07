import 'package:flutter/cupertino.dart';

class Patient with ChangeNotifier {
  final int? id;

  final String firstName;
  final String lastName;
  final int cardId;
  final String phone;
  final String email;
  final String address;
  final String? baseImage;
  final String? doctorName;

  Patient({
    required this.id,
    required this.baseImage,
    required this.firstName,
    required this.lastName,
    required this.cardId,
    required this.phone,
    required this.email,
    required this.address,
    required this.doctorName,
  });

  factory Patient.fromMap(Map<String, dynamic> json) {
    return Patient(
        id: json['id'],
        baseImage: json['profile_image'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        cardId: json['card_id'],
        phone: json['phone'] /* int.parse(json['phone']) */,
        email: json['email'],
        address: json['address'],
        doctorName: json['full_name']);
  }
}
