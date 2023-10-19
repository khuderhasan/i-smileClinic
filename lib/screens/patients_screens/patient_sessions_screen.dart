import 'package:flutter/material.dart';
import '../../core/constatnts.dart';

import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../providers/sessions.dart';
import '../../providers/patients.dart';
import '../../widgets/sessions/session_card.dart';
import '../../core/custom_shape.dart';
import '../../widgets/app_drawer.dart';
import '../../models/patient.dart';
import '../../widgets/sessions/add_session_bottom_sheet.dart';
import '../../core/shimmer_widgets.dart';

class PatinetSessionsScreen extends StatefulWidget {
  const PatinetSessionsScreen({Key? key}) : super(key: key);
  static const routeName = '/patient-sessions-screen';

  @override
  State<PatinetSessionsScreen> createState() => _PatinetSessionsScreenState();
}

class _PatinetSessionsScreenState extends State<PatinetSessionsScreen> {
  void refreshScreen() {
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final routArgs = ModalRoute.of(context)?.settings.arguments as int;
    final userType = Provider.of<Auth>(context, listen: false).userTyper;
    final id = routArgs;
    const myBlue = Color(0xff0177B6);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
// Info Drawer
        leading: IconButton(
          icon: const Icon(Icons.info),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 200,
        flexibleSpace: ClipPath(
          clipper: CustomShape(),
          child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            color: myBlue,
            // Patient Photo and Name
            child: FutureBuilder(
                future: Provider.of<Patients>(context, listen: false)
                    .getPatientById(id),
                builder: (context, AsyncSnapshot<Patient> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (snapshot.data!.baseImage == null)
                            ? const Icon(
                                Icons.account_circle,
                                size: 100,
                                color: Colors.white,
                              )
                            : CircleAvatar(
                                radius: 45,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    "$baseUrl/${snapshot.data!.baseImage!}",
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.account_circle,
                                      size: 100,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                        /*  Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        NetworkImage(snapshot.data!.imageUrl!),
                                  ),
                                ),
                              ), */
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${snapshot.data!.firstName} ${snapshot.data!.lastName}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return ShimmerWidgets.profileImageShimmer();
                }),
          ),
        ),
      ),
      // Sessions ListView
      body: FutureBuilder(
        future: Provider.of<Sessions>(context).getSessionsBysUserId(id),
        builder: (context, AsyncSnapshot snapshot) {
          // print(snapshot.data);
          if (snapshot.hasData) {
            if (snapshot.data['data'] != null) {
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data['data'].length,
                itemBuilder: (context, index) {
                  return SessionCard(
                    refreshScreen: refreshScreen,
                    patientId: id,
                    sessionId: snapshot.data['data'][index]['id'],
                    user: userType!,
                    notes: snapshot.data['data'][index]['notices'],
                    description: snapshot.data['data'][index]['description'],
                    sessionDate: snapshot.data['data'][index]['session_date'],
                    status: snapshot.data['data'][index]['status'],
                  );
                },
              );
            } else {
              return const Center(
                child: Text('There are no sessions'),
              );
            }
          }
          return ListView.builder(
            itemBuilder: (context, index) =>
                ShimmerWidgets.sessionCardShimmer(),
            itemCount: 2,
          );
        },
      ),
      //Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return DateTimePickerBottomSheet(
                  patientId: id,
                  kind: BottomSheetKind.Add,
                );
              }).then((_) => setState(() {}));
        },
        backgroundColor: myBlue,
        isExtended: true,
        child: const Icon(Icons.add),
      ),
      drawer: AppDrawer(
        id: id,
      ),
    );
  }
}
