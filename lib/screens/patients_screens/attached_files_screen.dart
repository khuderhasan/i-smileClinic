import 'package:flutter/material.dart';
import '../../core/app_localizations.dart';
import '../../providers/sessions.dart';
import '../../widgets/choose_image_bottom_sheet.dart';
import '../../widgets/patient/pinch_zoom_image.dart';
import 'package:provider/provider.dart';

class AttachedFilesScreen extends StatefulWidget {
  static const routName = "/attached-files-screen";
  const AttachedFilesScreen({super.key});

  @override
  State<AttachedFilesScreen> createState() => _AttachedFilesScreenState();
}

class _AttachedFilesScreenState extends State<AttachedFilesScreen> {
  _onRefresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final routArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, int?>;
    final patientId = routArgs['id'];
    return Scaffold(
      appBar: _buildAppBar(context, patientId!),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: Provider.of<Sessions>(context, listen: false)
              .getAttachedFiles(patientId),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data['data'].length == 0) {
                return Center(
                  child: Text("No Attached Images yet".tr(context)),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () => _onRefresh(),
                  child: ListView.builder(
                    itemBuilder: (context, index) => ZoomImage(
                        title: snapshot.data["data"][index]["name"],
                        imageUrl: snapshot.data["data"][index]["file"]),
                    itemCount: snapshot.data["data"].length,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, int id) {
    return AppBar(
      title: Text("AttachedFiles".tr(context)),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                builder: (builder) => ChooseImageBottomSheet(patientId: id),
              );
              setState(() {});
            },
            icon: const Icon(Icons.add)),
      ],
    );
  }
}
