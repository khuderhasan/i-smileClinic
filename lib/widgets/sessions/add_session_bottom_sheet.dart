import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../core/app_localizations.dart';
import '../../core/constatnts.dart';
import '../../providers/sessions.dart';

class DateTimePickerBottomSheet extends StatefulWidget {
  final int patientId;
  final BottomSheetKind kind;
  final int? sessionId;
  const DateTimePickerBottomSheet(
      {super.key, required this.patientId, required this.kind, this.sessionId});
  @override
  State<DateTimePickerBottomSheet> createState() =>
      _DateTimePickerBottomSheetState();
}

class _DateTimePickerBottomSheetState extends State<DateTimePickerBottomSheet> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Future<void> _presentDatePicker() async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 7)));

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _presentTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: (_selectedTime != null) ? _selectedTime! : TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 325.0,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              (widget.kind == BottomSheetKind.Add)
                  ? "Add New Session".tr(context)
                  : "Reschedual Session".tr(context),
              style: const TextStyle(fontSize: 16.0, color: myBlue),
            )),
            const SizedBox(height: 10.0),
            Text(
              "Date".tr(context),
              style: const TextStyle(fontSize: 16.0, color: myBlue),
            ),
            const SizedBox(height: 10.0),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Text(
                  _selectedDate == null
                      ? 'No Chosen Date'.tr(context)
                      : DateFormat('EEE, MMM d').format(_selectedDate!),
                  style: const TextStyle(fontSize: 16.0),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.date_range,
                    color: myBlue,
                  ),
                  onPressed: () {
                    _presentDatePicker();
                  },
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text('Time'.tr(context),
                style: const TextStyle(fontSize: 16.0, color: myBlue)),
            const SizedBox(height: 10.0),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Text(
                  _selectedTime == null
                      ? 'No Chosen Time'.tr(context)
                      : _selectedTime!.format(context),
                  style: const TextStyle(fontSize: 16.0),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.access_time,
                    color: myBlue,
                  ),
                  onPressed: () {
                    _presentTimePicker();
                  },
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: myBlue, shape: const StadiumBorder()),
                  onPressed: () async {
                    if (_selectedDate != null && _selectedTime != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime(
                              _selectedDate!.year,
                              _selectedDate!.month,
                              _selectedDate!.day,
                              _selectedTime!.hour,
                              _selectedTime!.minute));
                      // ignore: avoid_print
                      print(widget.patientId);
                      try {
                        if (widget.kind == BottomSheetKind.Add) {
                          await Provider.of<Sessions>(context, listen: false)
                              .addNewSession(widget.patientId, formattedDate)
                              .then((_) => Navigator.of(context).pop());
                        } else {
                          await Provider.of<Sessions>(context, listen: false)
                              .reschedualSession(widget.patientId,
                                  widget.sessionId, formattedDate)
                              .then((_) => Navigator.of(context).pop());
                        }
                      } catch (error) {
                        _showAlertDialogOnCallBack('Error'.tr(context),
                            error.toString(), DialogType.error, context, () {
                          Navigator.of(context).pop();
                        }, AnimType.rightSlide, Colors.red, null);
                      }
                    }
                  },
                  child: Text('Add'.tr(context)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: myBlue, shape: const StadiumBorder()),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'.tr(context)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
