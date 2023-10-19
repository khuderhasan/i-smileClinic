import 'package:flutter/material.dart';
import '../../core/app_localizations.dart';
import '../../widgets/alert_dialog.dart';

import 'package:provider/provider.dart';

import '../../providers/assistants.dart';

class AssistantsScreen extends StatefulWidget {
  const AssistantsScreen({super.key});
  static const routeName = '/assistants_screen';

  @override
  State<AssistantsScreen> createState() => _AssistantsScreenState();
}

class _AssistantsScreenState extends State<AssistantsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assistants'.tr(context)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await _addAssistantDialog(context).then((_) => setState(() {}));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future:
              Provider.of<Assistants>(context, listen: false).getAssistants(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data['error'] == null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.person_3_rounded),
                        title: Text('Assistant'.tr(context)),
                        subtitle: Text(snapshot.data['data'][index]['email']),
                        trailing: IconButton(
                            onPressed: () async {
                              await _deleteAssistant(
                                      snapshot.data['data'][index]['id'],
                                      context)
                                  .then((_) => setState(() {}));
                            },
                            icon: const Icon(Icons.delete)),
                      );
                    },
                    itemCount: snapshot.data['data'].length,
                  ),
                );
              } else {
                return Center(
                  child: Text('No Assitatnts yet'.tr(context)),
                );
              }
            }
          }),
    );
  }
}

Future<void> _deleteAssistant(int? id, BuildContext context) async {
  try {
    Provider.of<Assistants>(context, listen: false)
        .deleteAssistant(id)
        .then((_) {
      alertDialog(
          title: 'Success',
          message: 'Assistant deleted',
          context: context,
          color: const Color.fromARGB(255, 8, 156, 13));
    });
  } catch (exceptoin) {
    alertDialog(
      title: 'Error',
      message: 'Something went wrong',
      context: context,
      color: const Color.fromARGB(255, 221, 22, 8),
    );
  }
}

Future<void> _submit(
    String email, String password, BuildContext context) async {
  try {
    Provider.of<Assistants>(context, listen: false)
        .addAssistant(email, password)
        .then((_) {
      Navigator.of(context).pop();
      alertDialog(
          title: 'Success'.tr(context),
          message: 'AssistantAdded'.tr(context),
          context: context,
          color: const Color.fromARGB(255, 8, 156, 13));
    });
  } catch (exceptoin) {
    alertDialog(
      title: 'Error'.tr(context),
      message: 'SomethingWentWrong'.tr(context),
      context: context,
      color: const Color.fromARGB(255, 221, 22, 8),
    );
  }
}

Future<void> _addAssistantDialog(
  BuildContext context,
) async {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Cancel'.tr(context)),
            ),
            TextButton(
              onPressed: () async {
                await _submit(
                    emailController.text, passwordController.text, ctx);
              },
              child: Text('Add'.tr(context)),
            ),
          ],
          title: Text('AddAssistant'.tr(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Inter a Value'.tr(context);
                  }
                  return null;
                },
                controller: emailController,
                autofocus: true,
                decoration: InputDecoration(
                  label: Text('Email'.tr(context)),
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Inter a Value'.tr(context);
                  }
                  return null;
                },
                controller: passwordController,
                decoration: InputDecoration(
                  label: Text('Password'.tr(context)),
                ),
              ),
            ],
          ),
        );
      });
}
