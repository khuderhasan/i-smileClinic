import 'dart:io';

import 'package:flutter/material.dart';
import 'package:i_smile_clinic/providers/sessions.dart';
import 'package:i_smile_clinic/widgets/alert_dialog.dart';
import 'package:image_picker/image_picker.dart';

import 'package:i_smile_clinic/core/app_localizations.dart';
import 'package:provider/provider.dart';

class ChooseImageBottomSheet extends StatefulWidget {
  final int patientId;

  const ChooseImageBottomSheet({
    Key? key,
    required this.patientId,
  }) : super(key: key);

  @override
  State<ChooseImageBottomSheet> createState() => _ChooseImageBottomSheetState();
}

class _ChooseImageBottomSheetState extends State<ChooseImageBottomSheet> {
  File? imageFile;
  String? baseImage = '';
  TextEditingController titleController = TextEditingController();

  void _takePhoto(ImageSource img) async {
    var pickedImage =
        await ImagePicker().pickImage(source: img, imageQuality: 30);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
        baseImage = imageFile?.path.toString();
      });
    }
  }

  void _submit() async {
    try {
      await Provider.of<Sessions>(context, listen: false)
          .uploadImage(
              baseImage!, widget.patientId, titleController.text.toString())
          .then((_) => alertDialog(
              title: "Success".tr(context),
              message: "Image Uploaded Successfully".tr(context),
              context: context,
              color: Colors.green))
          .then((_) => Navigator.of(context).pop());
      // ignore: unused_catch_clause
    } on HttpException catch (exceptoin) {
      alertDialog(
          title: "Error".tr(context),
          message: "Error Image is not uploaded try again later".tr(context),
          context: context,
          color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (imageFile != null) ? 600 : 200,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: [
        Text(
          'Choose Photo'.tr(context),
          style: const TextStyle(fontSize: 20),
        ),
        (imageFile == null)
            ? const SizedBox(
                height: 20,
              )
            : Container(),
        (imageFile != null)
            ? SizedBox(
                height: 230,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.file(imageFile!),
                ),
              )
            : Container(),
        TextField(
          controller: titleController,
          decoration: InputDecoration(label: Text("Title".tr(context))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                _takePhoto(ImageSource.camera);
                // create _edited patient item and add the photo to it
              },
              icon: const Icon(Icons.camera),
              label: Text('Camera'.tr(context)),
            ),
            TextButton.icon(
              onPressed: () {
                _takePhoto(ImageSource.gallery);
              },
              icon: const Icon(Icons.image),
              label: Text('Gallery'.tr(context)),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel".tr(context)),
            ),
            ElevatedButton(
              onPressed: () => _submit(),
              child: Text("UploadImage".tr(context)),
            )
          ],
        )
      ]),
    );
  }
}
