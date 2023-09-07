import 'package:flutter/material.dart';
import 'package:i_smile_clinic/core/app_localizations.dart';
import 'package:i_smile_clinic/providers/doctors.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../models/patient.dart';
import '../../providers/auth.dart';
import '../../providers/patients.dart';
import '../../core/constatnts.dart';
import '../../widgets/patient/patient_card.dart';
import 'patient_sessions_screen.dart';
import '../../core/shimmer_widgets.dart';

class AllPatientsScreen extends StatefulWidget {
  static const routeName = '/all-patients-screen';

  const AllPatientsScreen({Key? key}) : super(key: key);

  @override
  State<AllPatientsScreen> createState() => _AllPatientsScreenState();
}

class _AllPatientsScreenState extends State<AllPatientsScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = false;
  late List<Patient> _patientsList;
  late List<Patient> _displayList;
  String? filterBy;

  @override
  void initState() {
    super.initState();
    _patientsList = [];
    _displayList = [];
    Provider.of<Doctors>(context, listen: false).getAllDoctors();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_patientsList.isEmpty) {
      _refreshPatients(filterBy);
    }
  }

  Future<void> _refreshPatients(String? doctorId) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Patients>(context, listen: false)
        .getAllPatients(doctorId);
    // ignore: use_build_context_synchronously
    _patientsList = Provider.of<Patients>(context, listen: false).patients;
    _displayList = List.from(_patientsList);
    setState(() {
      _isLoading = false;
    });
  }

  void _updateList(String value) {
    setState(() {
      _displayList = _patientsList
          .where((element) =>
              element.firstName.toLowerCase().contains(value.toLowerCase()) ||
              element.lastName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userType = Provider.of<Auth>(context, listen: false).userTyper;
    return Scaffold(
      backgroundColor: myBlue,
      body: Column(
        children: [
          AppBar(
            backgroundColor: myBlue,
            actions: (userType == UserType.Assistant)
                ? [
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: buildAppBarFilter()),
                  ]
                : [],
            centerTitle: true,
            title: Text(
              'Patients list'.tr(context),
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 100,
            color: myBlue,
            width: double.infinity,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) => _updateList(value),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none),
                    hintText: '  Patient name'.tr(context),
                    suffixIcon: const Icon(Icons.search),
                    suffixIconColor: Colors.blue),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                color: Colors.white,
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  await _refreshPatients(filterBy);
                },
                child: (_isLoading)
                    ? ListView.builder(
                        itemBuilder: (context, index) =>
                            ShimmerWidgets.patientCardShimmer(),
                        itemCount: 2,
                      )
                    : _displayList.isEmpty
                        ? Center(
                            child: Text(
                            'No Results Found!'.tr(context),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0),
                          ))
                        : ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) => PatientCard(
                              patientId: _displayList[index].id,
                              userType: userType,
                              firstName: _displayList[index].firstName,
                              lastName: _displayList[index].lastName,
                              doctorName: _displayList[index].doctorName!,
                              imagePath: _displayList[index].baseImage,
                              email: _displayList[index].email,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    PatinetSessionsScreen.routeName,
                                    arguments: _displayList[index].id);
                              },
                            ),
                            itemCount: _displayList.length,
                          ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget buildAppBarFilter() {
    return Consumer<Doctors>(
      builder: (context, doctorsProvider, _) {
        return DropdownButton<String>(
          iconEnabledColor: Colors.white,
          value: null,
          underline: Container(),
          items: [
            const DropdownMenuItem<String>(
              value: '0',
              child: Text('All Doctors'),
            ),
            ...doctorsProvider.doctors
                .map(
                  (doctor) => DropdownMenuItem<String>(
                    value: doctor.id.toString(),
                    child: Text('Dr.${doctor.fullName}'),
                  ),
                )
                .toList(),
          ],
          onChanged: (doctorId) {
            setState(() {
              filterBy = doctorId;
            });
            _refreshPatients(doctorId);
          },
          icon: const Icon(Icons.filter_list),
        );
      },
    );
  }
}
