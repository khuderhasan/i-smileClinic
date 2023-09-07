import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:i_smile_clinic/core/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/medical_report.dart';
import '../../models/patient.dart';
import '../../models/session.dart';
import '../../providers/patients.dart';
import 'home_screen.dart';
import '../../core/constatnts.dart';
import '../../widgets/steps/medical_step.dart';
import '../../widgets/steps/personal_step.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({Key? key}) : super(key: key);
  static const routeName = '/stepper-screen';

  @override
  State<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  final personalInfoKey = GlobalKey<FormState>();
  final medicalReportKey = GlobalKey<FormState>();
  GlobalKey<MedicalStepState> medicalStepKey = GlobalKey<MedicalStepState>();
  GlobalKey<PersonalStepState> personalStepKey = GlobalKey<PersonalStepState>();

  var editedPatient = Patient(
      id: null,
      baseImage: null,
      firstName: '',
      lastName: '',
      cardId: 0,
      phone: '',
      email: '',
      address: '',
      doctorName: '');
  var _editedSession = Session(
    sessionId: null,
    patientId: null,
    sessionDate: null,
    status: 0,
  );

  MedicalReport editedMedicalReport = MedicalReport(
      id: null,
      patientId: null,
      bloodGroup: '',
      age: 0,
      gender: '',
      allergies: '',
      bloodDisorder: '',
      diabetes: '',
      medications: '');

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 7),
      ),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void presentTimePicker() async {
    await showTimePicker(
      context: context,
      initialTime: (_selectedTime != null) ? _selectedTime! : TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _selectedTime = pickedTime;
      });
    });
  }

  int index = 0;
  bool lastStep = false;

  Future<void> _showAlertDialogOnCallBack(
      String title,
      String message,
      DialogType dialogType,
      BuildContext context,
      Function onOkPressed,
      AnimType animType,
      Color? btnOkColor,
      IconData? btnOkIcon) async {
    await AwesomeDialog(
      context: context,
      animType: AnimType.topSlide,
      dialogType: dialogType,
      title: title,
      desc: message,
      btnOkIcon: btnOkIcon,
      btnOkColor: btnOkColor,
      btnOkOnPress: () {
        onOkPressed;
      },
    ).show();
  }

  String image = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RegisterPatient".tr(context)),
        backgroundColor: myBlue,
        toolbarHeight: 70,
      ),
      body: Stepper(
        currentStep: index,
        onStepCancel: () {
          if (index > 0) {
            setState(() {
              index--;
            });
            if (index < 2) {
              setState(() {
                lastStep = false;
              });
            }
          }
        },
        onStepContinue: () {
          bool isValid = true;

          if (index == 0) {
            isValid = personalInfoKey.currentState!.validate();
          } else if (index == 1) {
            isValid = medicalReportKey.currentState!.validate();
          }

          setState(() {
            index = isValid && index < 2 ? index + 1 : index;
            lastStep = index == 2;
          });
        },
        onStepTapped: (int tap) {
          setState(() {
            index = tap;
          });
          if (index == 2) {
            setState(() {
              lastStep = true;
            });
          }
          if (index < 2) {
            setState(() {
              lastStep = false;
            });
          }
        },
        type: StepperType.horizontal,
        elevation: 0,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: lastStep
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          //saving the personal information
                          personalStepKey
                              .currentState?.widget.personalInfoKey.currentState
                              ?.save();
                          // saving the medical information
                          medicalStepKey.currentState?.widget.medicalReportKey
                              .currentState
                              ?.save();
                          // setting new values
                          editedPatient = personalStepKey
                              .currentState!.widget.editedPatient;

                          editedMedicalReport = medicalStepKey
                              .currentState!.widget.editedMedicalReport;
                          DateTime date = DateTime(
                            _selectedDate!.year,
                            _selectedDate!.month,
                            _selectedDate!.day,
                            _selectedTime!.hour,
                            _selectedTime!.minute,
                          );
                          _editedSession = Session(
                              sessionId: _editedSession.sessionId,
                              patientId: _editedSession.patientId,
                              sessionDate: date,
                              status: _editedSession.status);

                          try {
                            await Provider.of<Patients>(context, listen: false)
                                .addPatient(editedPatient, editedMedicalReport,
                                    _editedSession)
                                .then((_) async {
                              await _showAlertDialogOnCallBack(
                                'Success'.tr(context),
                                '${"Patient".tr(context)}: ${editedPatient.firstName} ${editedPatient.lastName} ${"was Rigested".tr(context)} ',
                                DialogType.success,
                                context,
                                (context) {
                                  Navigator.of(context).pop();
                                },
                                AnimType.topSlide,
                                Colors.green.shade900,
                                Icons.check_circle,
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.of(context)
                                  .pushReplacementNamed(HomeScreen.routeName);
                            });
                          } catch (error) {
                            print(error);
                            _showAlertDialogOnCallBack(
                                'Error'.tr(context),
                                error.toString(),
                                DialogType.error,
                                context, () {
                              Navigator.of(context).pop();
                            }, AnimType.rightSlide, Colors.red, null);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: myBlue,
                            shape: const StadiumBorder()),
                        child: Text("Register".tr(context)),
                      ),
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: Text(
                          "Cancel".tr(context),
                          style: const TextStyle(color: myBlue),
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: myBlue,
                            shape: const StadiumBorder()),
                        child: Text("Next".tr(context)),
                      ),
                      TextButton(
                          onPressed: details.onStepCancel,
                          child: Text(
                            "Cancel".tr(context),
                            style: const TextStyle(color: myBlue),
                          ))
                    ],
                  ),
          );
        },
        steps: <Step>[
          // step1
          Step(
            isActive: index >= 0,
            state: index == 0 ? StepState.editing : StepState.complete,
            title: Text('PersonalInfo'.tr(context)),
            content: PersonalStep(
              key: personalStepKey,
              editedPatient: editedPatient,
              personalInfoKey: personalInfoKey,
            ),
          ),
          // step2
          Step(
            isActive: index >= 1,
            state: index == 1
                ? StepState.editing
                : (index > 1)
                    ? StepState.complete
                    : StepState.disabled,
            title: Text('Medical Info'.tr(context)),
            content: MedicalStep(
              key: medicalStepKey,
              editedMedicalReport: editedMedicalReport,
              medicalReportKey: medicalReportKey,
            ),
          ),
          // step3
          Step(
            isActive: index >= 2,
            title: Text('Date'.tr(context)),
            content: Form(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No Chosen Date'.tr(context)
                            : '${"Date".tr(context)}:   ${DateFormat.yMd().format(_selectedDate!)}',
                      ),
                      IconButton(
                        onPressed: () {
                          presentDatePicker();
                        },
                        icon: const Icon(
                          Icons.date_range,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTime == null
                            ? 'No Chosen Time'.tr(context)
                            : '${"Time".tr(context)}:    ${_selectedTime!.format(context)}',
                      ),
                      IconButton(
                        onPressed: () {
                          presentTimePicker();
                        },
                        icon: const Icon(Icons.schedule),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
