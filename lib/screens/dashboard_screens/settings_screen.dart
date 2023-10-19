import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_localizations.dart';
import '../../providers/auth.dart';
import '../auth_screen.dart';
import 'package:provider/provider.dart';

import '../../core/constatnts.dart';
import '../../cubit/locale_cubit.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings_screen';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr(context)),
        centerTitle: true,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(
              Icons.language,
              color: Colors.teal,
            ),
            title: Text("ChangeLanguage".tr(context)),
            trailing: BlocConsumer<LocaleCubit, ChangeLocaleState>(
              listener: (context, state) {
                Navigator.of(context).pop();
              },
              builder: (context, state) {
                return DropdownButton<String>(
                  underline: Container(),
                  value: state.locale.languageCode,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: languages.map((lang) {
                    return DropdownMenuItem<String>(
                      value: lang["code"],
                      child: Text(lang["name"]),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      context.read<LocaleCubit>().changeLanguage(newValue);
                    }
                  },
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text("LOGOUT".tr(context)),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        )
      ]),
    );
  }
}
