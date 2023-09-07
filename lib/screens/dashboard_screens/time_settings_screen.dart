import 'package:flutter/material.dart';
import 'package:i_smile_clinic/core/app_localizations.dart';
import 'package:i_smile_clinic/models/http_exeption.dart';
import 'package:provider/provider.dart';

import '../../providers/patients.dart';
import '../../widgets/alert_dialog.dart';

class TimeSettingsScreen extends StatefulWidget {
  static const routeName = '/time_settings_screen';
  const TimeSettingsScreen({super.key});

  @override
  State<TimeSettingsScreen> createState() => _TimeSettingsScreenState();
}

TextEditingController cancelController = TextEditingController();
TextEditingController maxTimeController = TextEditingController();
TextEditingController minTimeController = TextEditingController();

bool _isEditing = false;

class _TimeSettingsScreenState extends State<TimeSettingsScreen> {
  @override
  void didChangeDependencies() async {
    Map<String, dynamic> constraints =
        await Provider.of<Patients>(context, listen: false)
            .getTimeConstraints();
    maxTimeController.text = constraints['maxTime'].toString();
    minTimeController.text = constraints['minTime'].toString();
    cancelController.text = constraints['cancelTime'].toString();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    saveChanges() async {
      try {
        await Provider.of<Patients>(context, listen: false).editTimeConstraints(
            cancelController.text,
            maxTimeController.text,
            minTimeController.text);
        // ignore: use_build_context_synchronously
        alertDialog(
            // ignore: use_build_context_synchronously
            title: 'Success'.tr(context),
            // ignore: use_build_context_synchronously
            message: 'ChangesSaved'.tr(context),
            context: context,
            color: Colors.green);
        setState(() {
          _isEditing = false;
        });
      } on HttpException catch (exception) {
        alertDialog(
            title: 'Error'.tr(context),
            color: const Color.fromARGB(255, 221, 22, 8),
            message: exception.message,
            context: context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings'.tr(context),
          style: const TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          _isEditing
              ? IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(2),
        child: SingleChildScrollView(
          child: Column(children: [
            TimeField(
                label: '${"BlokModificationTime".tr(context)} :',
                controller: cancelController),
            TimeField(
                label: '${"TimePerPatient".tr(context)} :',
                controller: maxTimeController),
            TimeField(
                label: '${"BlokSessionCompletion".tr(context)} :',
                controller: minTimeController),
            _isEditing
                ? ElevatedButton(
                    onPressed: saveChanges,
                    child: Text("SaveChanges".tr(context)))
                : Container()
          ]),
        ),
      ),
    );
  }
}

class TimeField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const TimeField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              label: Text('Minutes'.tr(context)),
              enabled: _isEditing,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            controller: controller,
          ),
        ],
      ),
    );
  }
}
