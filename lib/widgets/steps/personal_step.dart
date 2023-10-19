import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../core/app_localizations.dart';
import '../../providers/doctors.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/patient.dart';

// ignore: must_be_immutable
class PersonalStep extends StatefulWidget {
  Patient editedPatient;
  GlobalKey<FormState> personalInfoKey;

  PersonalStep({
    Key? key,
    required this.editedPatient,
    required this.personalInfoKey,
  }) : super(key: key);

  @override
  State<PersonalStep> createState() => PersonalStepState();
}

class PersonalStepState extends State<PersonalStep> {
  File? imageFile;
  String? baseImage = '';
  String? _doctorName;

  void _doctorNameOnChanged(String? doctorName) {
    setState(() {
      _doctorName = doctorName;
    });
  }

// compress function is here
  Future<List<int>> compressImage(String imagePath) async {
    final bytes = await FlutterImageCompress.compressWithFile(
      imagePath,
      quality: 20,
    );

    return bytes as List<int>;
  }

  // Here should be a variable that holds the image string
  void _takePhoto(ImageSource img) async {
    var pickedImage =
        await ImagePicker().pickImage(source: img, imageQuality: 30);
    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
      setState(() {
        baseImage = imageFile?.path.toString();
      });
    } else {}
  }

  //bottom sheet
  Widget chooseImageBottomSheet() {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: [
        Text(
          'Choose Photo'.tr(context),
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 20,
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
        Center(
          child: ElevatedButton(
            child: Text('Ok'.tr(context)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: widget.personalInfoKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextFormField(
                  decoration:
                      InputDecoration(labelText: 'First Name'.tr(context)),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Inter a Value'.tr(context);
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.editedPatient = Patient(
                        id: widget.editedPatient.id,
                        doctorName: widget.editedPatient.doctorName,
                        baseImage: baseImage,
                        firstName: value.toString(),
                        lastName: widget.editedPatient.lastName,
                        cardId: widget.editedPatient.cardId,
                        phone: widget.editedPatient.phone,
                        email: widget.editedPatient.email,
                        address: widget.editedPatient.address);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Last Name'.tr(context)),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Inter a Value'.tr(context);
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.editedPatient = Patient(
                        id: widget.editedPatient.id,
                        doctorName: widget.editedPatient.doctorName,
                        baseImage: baseImage,
                        firstName: widget.editedPatient.firstName,
                        lastName: value.toString(),
                        cardId: widget.editedPatient.cardId,
                        phone: widget.editedPatient.phone,
                        email: widget.editedPatient.email,
                        address: widget.editedPatient.address);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Email'.tr(context)),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Inter a Value'.tr(context);
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.editedPatient = Patient(
                        id: widget.editedPatient.id,
                        doctorName: widget.editedPatient.doctorName,
                        baseImage: baseImage,
                        firstName: widget.editedPatient.firstName,
                        lastName: widget.editedPatient.lastName,
                        cardId: widget.editedPatient.cardId,
                        phone: widget.editedPatient.phone,
                        email: value.toString(),
                        address: widget.editedPatient.address);
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Phone Number'.tr(context)),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Inter a Value'.tr(context);
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.editedPatient = Patient(
                        id: widget.editedPatient.id,
                        doctorName: widget.editedPatient.doctorName,
                        baseImage: baseImage,
                        firstName: widget.editedPatient.firstName,
                        lastName: widget.editedPatient.lastName,
                        cardId: widget.editedPatient.cardId,
                        phone: value! /* int.parse(value!) */,
                        email: widget.editedPatient.email,
                        address: widget.editedPatient.address);
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Living Address'.tr(context)),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Inter a Value'.tr(context);
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.editedPatient = Patient(
                        id: widget.editedPatient.id,
                        doctorName: widget.editedPatient.doctorName,
                        baseImage: baseImage,
                        firstName: widget.editedPatient.firstName,
                        lastName: widget.editedPatient.lastName,
                        cardId: widget.editedPatient.cardId,
                        phone: widget.editedPatient.phone,
                        email: widget.editedPatient.email,
                        address: value.toString());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Card Id'.tr(context)),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Inter a Value'.tr(context);
                    }
                    return null;
                  },
                  onSaved: (value) {
                    widget.editedPatient = Patient(
                        id: widget.editedPatient.id,
                        doctorName: widget.editedPatient.doctorName,
                        baseImage: baseImage,
                        firstName: widget.editedPatient.firstName,
                        lastName: widget.editedPatient.lastName,
                        cardId: /* value! */ int.parse(value!),
                        phone: widget.editedPatient.phone,
                        email: widget.editedPatient.email,
                        address: widget.editedPatient.address);
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Consumer<Doctors>(
                  builder: (context, doctorsProvider, _) {
                    return DropdownButtonFormField<String>(
                      value: null,
                      hint: Text('Doctor'.tr(context)),
                      items: doctorsProvider.doctors
                          .map(
                            (doctor) => DropdownMenuItem<String>(
                              value: doctor.fullName.toString(),
                              child: Text('Dr.${doctor.fullName}'),
                            ),
                          )
                          .toList(),
                      onChanged: _doctorNameOnChanged,
                      onSaved: (doctorName) {
                        widget.editedPatient = Patient(
                            id: widget.editedPatient.id,
                            baseImage: baseImage,
                            firstName: widget.editedPatient.firstName,
                            lastName: widget.editedPatient.lastName,
                            cardId: widget.editedPatient.cardId,
                            phone: widget.editedPatient.phone,
                            email: widget.editedPatient.email,
                            address: widget.editedPatient.address,
                            doctorName: doctorName.toString());
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: imageFile == null
                          ? Text('Photo Privew'.tr(context))
                          : FittedBox(
                              fit: BoxFit.contain,
                              child: Image.file(imageFile!),
                            ),
                    ),
                    Expanded(
                      child: TextButton(
                        autofocus: false,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (builder) => chooseImageBottomSheet(),
                          );
                        },
                        child: Text('Choose Photo'.tr(context)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
