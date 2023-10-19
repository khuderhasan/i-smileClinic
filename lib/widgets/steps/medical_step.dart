import 'package:flutter/material.dart';
import '../../core/app_localizations.dart';

import '../../core/constatnts.dart';
import '../../models/medical_report.dart';

// ignore: must_be_immutable
class MedicalStep extends StatefulWidget {
  MedicalReport editedMedicalReport;
  GlobalKey<FormState> medicalReportKey;

  MedicalStep({
    super.key,
    required this.editedMedicalReport,
    required this.medicalReportKey,
  });

  @override
  State<MedicalStep> createState() => MedicalStepState();
}

class MedicalStepState extends State<MedicalStep> {
  String? _bloodGroup;

  void _bloodGroupOnChanged(String? value) {
    setState(() {
      _bloodGroup = value;
    });
  }

  String? _gender;

  void _genderOnChanged(String? value) {
    setState(() {
      _gender = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: widget.medicalReportKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: DropdownButtonFormField(
                      hint: Text('Blood Group'.tr(context)),
                      autofocus: true,
                      disabledHint: Text('Blood Group'.tr(context)),
                      menuMaxHeight: 150,
                      onSaved: (value) {
                        widget.editedMedicalReport = MedicalReport(
                          id: widget.editedMedicalReport.id,
                          patientId: widget.editedMedicalReport.patientId,
                          bloodGroup: value.toString(),
                          age: widget.editedMedicalReport.age,
                          gender: widget.editedMedicalReport.gender,
                          allergies: widget.editedMedicalReport.allergies,
                          bloodDisorder:
                              widget.editedMedicalReport.bloodDisorder,
                          diabetes: widget.editedMedicalReport.diabetes,
                          medications: widget.editedMedicalReport.medications,
                        );
                      },
                      // Drop down list
                      items: groupList,
                      value: _bloodGroup,
                      onChanged: _bloodGroupOnChanged,
                      validator: (value) {
                        if (value == null) {
                          return 'Please choose a blood group'.tr(context);
                        }
                        return null;
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: TextFormField(
                    decoration:
                        InputDecoration(labelText: "BloodDisorder".tr(context)),
                    textInputAction: TextInputAction.next,
                    /*  validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            }, */
                    onSaved: (value) {
                      widget.editedMedicalReport = MedicalReport(
                        id: widget.editedMedicalReport.id,
                        patientId: widget.editedMedicalReport.patientId,
                        bloodGroup: widget.editedMedicalReport.bloodGroup,
                        age: widget.editedMedicalReport.age,
                        gender: widget.editedMedicalReport.gender,
                        allergies: widget.editedMedicalReport.allergies,
                        bloodDisorder: value,
                        diabetes: widget.editedMedicalReport.diabetes,
                        medications: widget.editedMedicalReport.medications,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Allergies'.tr(context)),
                    textInputAction: TextInputAction.next,
                    /* validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            }, */
                    onSaved: (value) {
                      widget.editedMedicalReport = MedicalReport(
                        id: widget.editedMedicalReport.id,
                        patientId: widget.editedMedicalReport.patientId,
                        bloodGroup: widget.editedMedicalReport.bloodGroup,
                        age: widget.editedMedicalReport.age,
                        gender: widget.editedMedicalReport.gender,
                        allergies: value,
                        bloodDisorder: widget.editedMedicalReport.bloodDisorder,
                        diabetes: widget.editedMedicalReport.diabetes,
                        medications: widget.editedMedicalReport.medications,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Diabeties'.tr(context)),
                    textInputAction: TextInputAction.next,
                    /*      validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            }, */
                    onSaved: (value) {
                      widget.editedMedicalReport = MedicalReport(
                        id: widget.editedMedicalReport.id,
                        patientId: widget.editedMedicalReport.patientId,
                        bloodGroup: widget.editedMedicalReport.bloodGroup,
                        age: widget.editedMedicalReport.age,
                        gender: widget.editedMedicalReport.gender,
                        allergies: widget.editedMedicalReport.allergies,
                        bloodDisorder: widget.editedMedicalReport.bloodDisorder,
                        diabetes: value,
                        medications: widget.editedMedicalReport.medications,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Age'.tr(context)),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Inter a Value'.tr(context);
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.editedMedicalReport = MedicalReport(
                        id: widget.editedMedicalReport.id,
                        patientId: widget.editedMedicalReport.patientId,
                        bloodGroup: widget.editedMedicalReport.bloodGroup,
                        age: int.parse(value!),
                        gender: widget.editedMedicalReport.gender,
                        allergies: widget.editedMedicalReport.allergies,
                        bloodDisorder: widget.editedMedicalReport.bloodDisorder,
                        diabetes: widget.editedMedicalReport.diabetes,
                        medications: widget.editedMedicalReport.medications,
                      );
                    },
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: DropdownButtonFormField(
                    hint: Text('Gender'.tr(context)),
                    items: gernderList,
                    value: _gender,
                    onChanged: _genderOnChanged,
                    onSaved: (value) {
                      widget.editedMedicalReport = MedicalReport(
                        id: widget.editedMedicalReport.id,
                        patientId: widget.editedMedicalReport.patientId,
                        bloodGroup: widget.editedMedicalReport.bloodGroup,
                        age: widget.editedMedicalReport.age,
                        gender: value.toString(),
                        allergies: widget.editedMedicalReport.allergies,
                        bloodDisorder: widget.editedMedicalReport.bloodDisorder,
                        diabetes: widget.editedMedicalReport.diabetes,
                        medications: widget.editedMedicalReport.medications,
                      );
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please Inter a Value'.tr(context);
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Medications'.tr(context)),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      widget.editedMedicalReport = MedicalReport(
                        id: widget.editedMedicalReport.id,
                        patientId: widget.editedMedicalReport.patientId,
                        bloodGroup: widget.editedMedicalReport.bloodGroup,
                        age: widget.editedMedicalReport.age,
                        gender: widget.editedMedicalReport.gender,
                        allergies: widget.editedMedicalReport.allergies,
                        bloodDisorder: widget.editedMedicalReport.bloodDisorder,
                        diabetes: widget.editedMedicalReport.diabetes,
                        medications: value,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
