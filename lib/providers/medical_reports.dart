import 'package:flutter/cupertino.dart';

import '../models/medical_report.dart';

class MedicalReports with ChangeNotifier {
  final List<MedicalReport> _reports = [];

  List<MedicalReport> get reports {
    return [..._reports];
  }

  /*  void addReport(MedicalReport report) {
    final MedicalReport newReport = MedicalReport(
      patientId: report.patientId,
      bloodDisorder: report.bloodDisorder,
      bloodGroup: report.bloodGroup,
      allergies: report.allergies,
      diabetes: report.diabetes,
    );
    _reports.add(newReport);
    notifyListeners();
  } */
}
