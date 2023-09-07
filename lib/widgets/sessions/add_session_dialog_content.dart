import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSessionDialogContent extends StatefulWidget {
  const AddSessionDialogContent({
    Key? key,
    required this.onDateSelected,
    required this.onTimeSelected,
  }) : super(key: key);

  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;

  @override
  _AddSessionDialogContentState createState() =>
      _AddSessionDialogContentState();
}

class _AddSessionDialogContentState extends State<AddSessionDialogContent> {
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
      widget.onDateSelected(pickedDate);
    }
  }

  Future<void> _presentTimePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
      widget.onTimeSelected(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null
                  ? 'No Chosen Date'
                  : DateFormat.yMd().format(_selectedDate!),
            ),
            IconButton(
              onPressed: _presentDatePicker,
              icon: const Icon(Icons.date_range),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedTime == null
                  ? 'No Chosen Time'
                  : _selectedTime!.format(context),
            ),
            IconButton(
              onPressed: _presentTimePicker,
              icon: const Icon(Icons.schedule),
            )
          ],
        ),
      ],
    );
  }
}
