import 'package:flutter/material.dart';
import '../../core/app_localizations.dart';
import '../../models/helper/medical_report_helper.dart';
import '../../widgets/alert_dialog.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../core/constatnts.dart';
import '../../models/medical_report.dart';
import '../../providers/patients.dart';

class MedicalInfoScreen extends StatefulWidget {
  static const routeName = '/medical-info-screen';

  const MedicalInfoScreen({Key? key}) : super(key: key);

  @override
  State<MedicalInfoScreen> createState() => _MedicalInfoScreenState();
}

class _MedicalInfoScreenState extends State<MedicalInfoScreen> {
  final fromkey = GlobalKey<FormState>();
  late bool _isEditing;
  @override
  void initState() {
    super.initState();
    _isEditing = false;
  }

  // ignore: prefer_final_fields
  MedicalReportHelper _editedMedicalReport = MedicalReportHelper(
    age: 0,
    allergies: '',
    bloodDisorder: '',
    bloodGroup: '',
    diabetes: '',
    gender: '',
    medications: '',
    patientId: null,
  );

  @override
  Widget build(BuildContext context) {
    final routArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, int?>;
    final id = routArgs['id'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Information'.tr(context)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Patients>(context).getMedicalReportById(id),
        builder: (context, AsyncSnapshot<MedicalReport> snapshot) {
          if (snapshot.hasData) {
            return _buildInfo(snapshot, id, groupList);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildInfo(AsyncSnapshot<MedicalReport> medicalReport, int? id,
      List<DropdownMenuItem<String>> groupList) {
    String? bloodGroup = medicalReport.data!.bloodGroup.toString();

    void bloodGroupOnChanged(String? value) {
      setState(() {
        bloodGroup = value;
        _editedMedicalReport.bloodGroup = bloodGroup;
      });
    }

    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(5),
          child: Card(
            color: Colors.white,
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(15),
              child: Form(
                key: fromkey,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.person, color: myBlue),
                      title: _isEditing
                          ? TextFormField(
                              decoration: InputDecoration(
                                  label: Text("Age".tr(context))),
                              initialValue: medicalReport.data!.age.toString(),
                              onSaved: (value) {
                                if (value != null) {
                                  int helper = int.parse(value);
                                  _editedMedicalReport.age = helper;
                                }
                              },
                            )
                          : Text("Age".tr(context),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                      subtitle: _isEditing
                          ? null
                          : Text("${medicalReport.data!.age}",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.person, color: myBlue),
                      title: Text("Gender".tr(context),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black)),
                      subtitle: Text(medicalReport.data!.gender,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.bloodtype, color: myBlue),
                      title: _isEditing
                          ? DropdownButtonFormField(
                              hint: Text('Blood Group'.tr(context)),
                              disabledHint: Text('Blood Group'.tr(context)),
                              menuMaxHeight: 150,
                              onSaved: (value) {
                                _editedMedicalReport.bloodGroup.toString();
                              },
                              // Drop down list
                              items: groupList,
                              value: medicalReport.data!.bloodGroup,
                              onChanged: bloodGroupOnChanged,
                            )
                          : Text("Blood Group".tr(context),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                      subtitle: _isEditing
                          ? null
                          : Text("${medicalReport.data!.bloodGroup} ",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.medication, color: myBlue),
                      title: _isEditing
                          ? TextFormField(
                              decoration: InputDecoration(
                                  label: Text("BloodDisorder".tr(context))),
                              initialValue:
                                  medicalReport.data!.bloodDisorder.toString(),
                              onSaved: (value) {
                                _editedMedicalReport.bloodDisorder = value;
                              },
                            )
                          : Text("BloodDisorder".tr(context),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                      subtitle: _isEditing
                          ? null
                          : Text(medicalReport.data!.bloodDisorder.toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.medication, color: myBlue),
                      title: _isEditing
                          ? TextFormField(
                              decoration: InputDecoration(
                                  label: Text("Allergies".tr(context))),
                              initialValue:
                                  medicalReport.data!.allergies.toString(),
                              onSaved: (value) {
                                _editedMedicalReport.allergies = value;
                              },
                            )
                          : Text("Allergies".tr(context),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                      subtitle: _isEditing
                          ? null
                          : Text(medicalReport.data!.allergies.toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.medication, color: myBlue),
                      title: _isEditing
                          ? TextFormField(
                              decoration: InputDecoration(
                                  label: Text("Diabeties".tr(context))),
                              initialValue:
                                  medicalReport.data!.diabetes.toString(),
                              onSaved: (value) {
                                _editedMedicalReport.diabetes = value;
                              },
                            )
                          : Text("Diabeties".tr(context),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                      subtitle: _isEditing
                          ? null
                          : Text(medicalReport.data!.diabetes.toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.medication, color: myBlue),
                      title: _isEditing
                          ? TextFormField(
                              decoration: InputDecoration(
                                  label: Text("Medications".tr(context))),
                              initialValue:
                                  medicalReport.data!.medications.toString(),
                              onSaved: (value) {
                                _editedMedicalReport.bloodGroup = bloodGroup;
                                _editedMedicalReport.gender =
                                    medicalReport.data!.gender;
                                _editedMedicalReport.medications =
                                    value.toString();
                              },
                            )
                          : Text("Medications".tr(context),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                      subtitle: _isEditing
                          ? null
                          : Text(medicalReport.data!.medications.toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    _isEditing
                        ? ElevatedButton(
                            onPressed: () {
                              fromkey.currentState?.save();
                              _submitChanges(_editedMedicalReport, id);
                            },
                            child: Text('SaveChanges'.tr(context)))
                        : Container(),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Future<void> _submitChanges(
      MedicalReportHelper medicalReport, int? id) async {
    try {
      await Provider.of<Patients>(context, listen: false)
          .updateMedicalInfo(medicalReport, id!);
      // ignore: use_build_context_synchronously
      alertDialog(
          // ignore: use_build_context_synchronously
          title: 'Success'.tr(context),
          // ignore: use_build_context_synchronously
          message: 'Medical Info Updated Successfully'.tr(context),
          context: context,
          color: Colors.green);
      setState(() {
        _isEditing = false;
      });
    } catch (exception) {
      alertDialog(
          title: 'Error'.tr(context),
          message: exception.toString(),
          context: context,
          color: Colors.red);
    }
  }
}
