import 'package:flutter/material.dart';
import '../../core/app_localizations.dart';
import '../../core/constatnts.dart';
import '../../providers/patients.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

class PatientCard extends StatelessWidget {
  final String? imagePath;
  final int? patientId;
  final String firstName;
  final String lastName;
  final String doctorName;

  final String email;
  final Function onTap;
  final UserType? userType;

  const PatientCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.doctorName,
    required this.imagePath,
    required this.email,
    required this.onTap,
    required this.userType,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(patientId),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await Provider.of<Patients>(context, listen: false)
            .deletePatient(patientId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
              title: Text(
                "Warning".tr(context),
                style: const TextStyle(color: Colors.red),
              ),
              content: Text(
                  "Are you sure you want to delete this patient ?".tr(context)),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('No'.tr(context))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('Yes'.tr(context))),
                  ],
                )
              ]),
        );
      },
      child: InkWell(
        onTap: () {
          onTap();
        },
        splashColor: Colors.white12,
        child: Card(
          margin: const EdgeInsets.all(10.0),
          borderOnForeground: true,
          shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: Container(
                margin: const EdgeInsets.only(left: 5),
                height: 130,
                width: 50,
                child: (imagePath == null)
                    ? const Icon(Icons.account_circle, size: 55)
                    : CircleAvatar(
                        backgroundImage: NetworkImage("$baseUrl/$imagePath"),
                      )),
            title: Text(
              '$firstName $lastName',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Lato',
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                email,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            trailing: (userType == UserType.Assistant)
                ? Text(
                    'Dr: $doctorName',
                    style: const TextStyle(fontSize: 12),
                  )
                : const Text(''),
          ),
        ),
      ),
    );
  }
}
