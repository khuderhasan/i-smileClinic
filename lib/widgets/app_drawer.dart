import 'package:flutter/material.dart';
import '../core/app_localizations.dart';
import '../screens/patients_screens/attached_files_screen.dart';
import '../screens/patients_screens/personal_info_screen.dart';
import '../screens/patients_screens/medical_info_screen.dart';

class AppDrawer extends StatelessWidget {
  int? id;
  AppDrawer({required this.id});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Info'.tr(context)),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('PersonalInfo'.tr(context)),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(PersonalInfoScreen.routeName, arguments: {
                'id': id,
              });
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.local_hospital_rounded),
            title: Text('MedicalInfo'.tr(context)),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(MedicalInfoScreen.routeName, arguments: {
                'id': id,
              });
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.file_present_rounded),
            title: Text('AttachedFiles'.tr(context)),
            onTap: () {
              Navigator.of(context).pushNamed(AttachedFilesScreen.routName,
                  arguments: {"id": id});
            },
          ),
        ],
      ),
    );
  }
}
