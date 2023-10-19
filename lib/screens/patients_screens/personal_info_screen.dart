import 'package:flutter/material.dart';
import '../../core/app_localizations.dart';
import '../../models/helper/patient_helper.dart';
import '../../widgets/alert_dialog.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../core/constatnts.dart';
import '../../models/patient.dart';
import '../../providers/patients.dart';

class PersonalInfoScreen extends StatefulWidget {
  static const routeName = '/personal-info-screen';

  PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final fromkey = GlobalKey<FormState>();
  late bool _isEditing;
  @override
  void initState() {
    super.initState();
    _isEditing = false;
  }

  // ignore: prefer_final_fields
  PatientHelper _editedPatient = PatientHelper(
    firstName: '',
    lastName: '',
    cardId: null,
    phone: 0,
    email: '',
    address: '',
  );

  @override
  Widget build(BuildContext context) {
    final routArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, int?>;
    final id = routArgs['id'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'.tr(context)),
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
        future: Provider.of<Patients>(context).getPatientById(id),
        builder: (context, AsyncSnapshot<Patient> snapshot) {
          if (snapshot.hasData) {
            return _buildInfo(snapshot, id);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildInfo(AsyncSnapshot<Patient> patient, int? id) {
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
                      title: Text("FullName".tr(context),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black)),
                      subtitle: Text(
                          "${patient.data!.firstName} ${patient.data!.lastName}",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email, color: myBlue),
                      title: _isEditing
                          ? TextFormField(
                              decoration: InputDecoration(
                                  label: Text("Email".tr(context))),
                              initialValue: patient.data!.email,
                              onSaved: (value) {
                                _editedPatient.email = value;
                              },
                            )
                          : Text("Email".tr(context),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                      subtitle: _isEditing
                          ? null
                          : Text("${patient.data!.email} ",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone, color: myBlue),
                      title: _isEditing
                          ? TextFormField(
                              decoration: InputDecoration(
                                  label: Text("Phone Number".tr(context))),
                              initialValue: patient.data!.phone.toString(),
                              onSaved: (value) {
                                if (value != null) {
                                  int help = int.parse(value);
                                  _editedPatient.phone = help;
                                }
                              },
                            )
                          : Text("Phone Number".tr(context),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                      subtitle: _isEditing
                          ? null
                          : Text(patient.data!.phone.toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.star_border_outlined, color: myBlue),
                      title:
                          //  _isEditing
                          //     ? TextFormField(
                          //         decoration: InputDecoration(
                          //             label: Text("Card Id".tr(context))),
                          //         keyboardType: TextInputType.number,
                          //         initialValue: patient.data!.cardId.toString(),
                          //         onSaved: (value) {
                          //           if (value != null) {
                          //             int help = int.parse(value);
                          //             _editedPatient.cardId = help;
                          //           }
                          //         },
                          //       )
                          //     :
                          Text("Card Id".tr(context),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                      subtitle:
                          // _isEditing
                          //     ? null
                          //     :
                          Text(patient.data!.cardId.toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      leading: const Icon(Icons.location_on, color: myBlue),
                      title: _isEditing
                          ? TextFormField(
                              decoration: InputDecoration(
                                  label: Text("Living Address".tr(context))),
                              initialValue: patient.data!.address,
                              onSaved: (value) {
                                _editedPatient.address = value;
                                _editedPatient.firstName =
                                    patient.data!.firstName;
                                _editedPatient.lastName =
                                    patient.data!.lastName;
                              },
                            )
                          : Text("Living Address".tr(context),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                      subtitle: _isEditing
                          ? null
                          : Text(patient.data!.address,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                    ),
                    _isEditing
                        ? ElevatedButton(
                            onPressed: () {
                              fromkey.currentState?.save();
                              _submitChanges(_editedPatient, id);
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

  Future<void> _submitChanges(PatientHelper patient, int? id) async {
    try {
      await Provider.of<Patients>(context, listen: false)
          .updatePersonalInfo(patient, id!);
      // ignore: use_build_context_synchronously
      alertDialog(
          // ignore: use_build_context_synchronously
          title: 'Success'.tr(context),
          // ignore: use_build_context_synchronously
          message: 'Personal Info Updated Successfully'.tr(context),
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
