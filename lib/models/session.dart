class Session {
  final int? patientId;

  final int? sessionId;

  final DateTime? sessionDate;
  final String? notices;

  final String? description;
  final int status;

  Session(
      {required this.sessionId,
      required this.patientId,
      required this.sessionDate,
      required this.status,
      this.notices,
      this.description});

  factory Session.fromMap(Map<String, dynamic> json) {
    return Session(
        sessionId: json['id'],
        patientId: json['patient_id'],
        sessionDate: json['session_date'],
        status: json['status'],
        notices: json['notices'],
        description: json['description']);
  }
}
