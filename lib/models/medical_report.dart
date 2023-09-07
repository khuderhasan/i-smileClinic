class MedicalReport {
  final int? id;
  final int? patientId;

  final String bloodGroup;
  final int age;
  final String gender;

  final String? allergies;
  final String? bloodDisorder;
  final String? diabetes;
  final String? medications;

  MedicalReport({
    required this.id,
    required this.patientId,
    required this.bloodGroup,
    required this.age,
    required this.gender,
    required this.allergies,
    required this.bloodDisorder,
    required this.diabetes,
    required this.medications,
  });

  factory MedicalReport.fromMap(Map<String, dynamic> json) {
    return MedicalReport(
        id: json['id'],
        patientId: json['patient_id'],
        bloodGroup: json['blood_group'],
        age: json['age'],
        gender: json['gender'],
        allergies: json['alergies'],
        bloodDisorder: json['blood_disorder'],
        diabetes: json['diabetes'],
        medications: json['medications']);
  }
}
