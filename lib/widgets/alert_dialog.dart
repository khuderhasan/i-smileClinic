import 'package:flutter/material.dart';
import 'package:i_smile_clinic/core/app_localizations.dart';

Future<void> alertDialog(
    {required title,
    required String message,
    required BuildContext context,
    required color}) {
  return showDialog(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontSize: 20, color: color),
      ),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('Okay'.tr(context)),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
