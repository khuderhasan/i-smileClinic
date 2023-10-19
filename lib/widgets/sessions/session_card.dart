import 'package:flutter/material.dart';
import '../../core/app_localizations.dart';
import '../../providers/auth.dart';
import 'add_session_bottom_sheet.dart';
import '../../providers/sessions.dart';
import '../alert_dialog.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../../core/constatnts.dart';

class SessionCard extends StatefulWidget {
  final int patientId;
  final int sessionId;
  final String sessionDate;
  final int status;
  final String? notes;
  final String? description;
  final VoidCallback refreshScreen;
  final UserType user;

  const SessionCard(
      {super.key,
      this.notes,
      this.description,
      required this.patientId,
      required this.user,
      required this.sessionId,
      required this.sessionDate,
      required this.status,
      required this.refreshScreen});

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  bool _isExpanded = false;
  bool _isEditing = false;
  TextEditingController noteController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    noteController.text = (widget.notes != null) ? widget.notes! : '';
    descriptionController.text =
        (widget.description != null) ? widget.description! : '';
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  _confirmDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Warning".tr(context),
          style: const TextStyle(fontSize: 20, color: Colors.red),
        ),
        content:
            Text("Are you sure you want to delete this session?".tr(context)),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("No".tr(context)),
          ),
          TextButton(
            onPressed: () {
              _cancelSession(context);
            },
            child: Text(
              "Yes".tr(context),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _cancelSession(BuildContext context) async {
    try {
      await Provider.of<Sessions>(context, listen: false)
          .cancelSession(widget.sessionId, widget.patientId)
          .then((_) => alertDialog(
              title: "Success".tr(context),
              message: "Session Was Deleted".tr(context),
              context: context,
              color: Colors.green))
          .then((_) => {widget.refreshScreen(), Navigator.of(context).pop()});
    } catch (exception) {
      alertDialog(
        title: 'Error'.tr(context),
        message: exception.toString(),
        context: context,
        color: Colors.red,
      );
    }
  }

  Future<void> _reschedualSession() async {
    return await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return DateTimePickerBottomSheet(
            patientId: widget.patientId,
            kind: BottomSheetKind.Reschedual,
            sessionId: widget.sessionId,
          );
        });
  }

  void _saveChanges(
    String notes,
    String description,
    int patientId,
    int sessionId,
  ) async {
    try {
      await Provider.of<Sessions>(context, listen: false)
          .updateSessionsDetailsAndNotes(
        description,
        notes,
        patientId,
        sessionId,
      );
      // ignore: use_build_context_synchronously
      alertDialog(
          // ignore: use_build_context_synchronously
          title: "Success".tr(context),
          // ignore: use_build_context_synchronously
          message: "Changes Were Updated Successfully".tr(context),
          context: context,
          color: Colors.green);
      setState(() {
        _isExpanded = false;
        _isEditing = false;
      });
    } catch (exception) {
      alertDialog(
        title: 'Error'.tr(context),
        message: exception.toString(),
        context: context,
        color: Colors.red,
      );
      setState(() {
        _isExpanded = false;
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(widget.sessionDate);
    return Column(
      children: [
        Card(
          elevation: _isExpanded ? 0 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: _isExpanded
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                : BorderRadius.circular(20.0),
          ),
          borderOnForeground: true,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.medical_services_outlined,
                color: myBlue,
              ),
            ),
            title: Text(
                '${"Date".tr(context)} :${DateFormat('EEE, MMM d').format(date)}'),
            subtitle: Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 5, 5),
              child: Text(
                '${"Time".tr(context)} : ${DateFormat.jm().format(date)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                (_isExpanded == true && widget.user == UserType.Doctor)
                    ? IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            if (widget.status == 1) {
                              _reschedualSession().then((_) => setState(() {
                                    _isEditing = false;
                                    _isExpanded = false;
                                    widget.refreshScreen();
                                  }));
                            } else {
                              _isEditing = !_isEditing;
                            }
                          });
                        },
                      )
                    : (widget.status == 1)
                        ? IconButton(
                            onPressed: () {
                              _confirmDialog(context);
                            },
                            icon: const Icon(Icons.delete),
                          )
                        : Container(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon: _isExpanded
                      ? const Icon(Icons.expand_less)
                      : const Icon(Icons.expand_more),
                ),
                (widget.status == 1)
                    ? const Icon(
                        Icons.circle,
                        color: Colors.green,
                      )
                    : const Icon(Icons.check_circle_outlined),
              ],
            ),
          ),
        ),
        _isExpanded
            ? Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                child: Column(children: [
                  (widget.user == UserType.Doctor)
                      ? TextField(
                          decoration: InputDecoration(
                            label: Text('Description'.tr(context)),
                          ),
                          controller: descriptionController,
                          enabled: (widget.status == 1 &&
                              widget.user == UserType.Doctor),
                          maxLines: 2,
                        )
                      : Container(),
                  TextField(
                    decoration: InputDecoration(
                      label: Text('Notices'.tr(context)),
                    ),
                    controller: noteController,
                    enabled: (_isEditing || widget.status == 1) &&
                        (widget.user == UserType.Doctor),
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  (_isEditing || widget.status == 1) &&
                          (widget.user == UserType.Doctor)
                      ? ElevatedButton(
                          onPressed: () {
                            _saveChanges(
                                noteController.text,
                                descriptionController.text,
                                widget.patientId,
                                widget.sessionId);
                          },
                          child: Text('SaveChanges'.tr(context)),
                        )
                      : Container()
                ]),
              )
            : Container(),
        if (widget.status == 1)
          const Divider(
            thickness: 2,
            indent: 30,
            endIndent: 30,
            color: Colors.black,
          )
      ],
    );
  }
}
