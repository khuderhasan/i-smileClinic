import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import '../../core/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constatnts.dart';
import '../../core/shimmer_widgets.dart';
import '../../providers/auth.dart';
import '../../providers/doctors.dart';
import '../../providers/sessions.dart';
import '../../widgets/patient/schedule_patient_card.dart';
import '../patients_screens/patient_sessions_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);
  static const routeName = '/schedule_screen';

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

late DateTime _selectedDate;

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    _selectedDate = DateTime.now();
    super.initState();
  }

  String? filterBy;

  @override
  Widget build(BuildContext context) {
    final userType = Provider.of<Auth>(context, listen: false).userTyper;
    String date = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule'.tr(context),
        ),
        centerTitle: true,
        backgroundColor: myBlue,
        actions: (userType == UserType.Assistant)
            ? [
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: buildAppBarFilter(date)),
              ]
            : [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Date Picker
          Container(
            margin: const EdgeInsets.all(5),
            child: DatePicker(
              DateTime.now(),
              height: 120,
              width: 80,
              initialSelectedDate: DateTime.now(),
              daysCount: 8,
              selectionColor: myBlue,
              selectedTextColor: Colors.white,
              dateTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              onDateChange: (value) {
                setState(() {
                  _selectedDate = value;
                  String date = DateFormat('yyyy-MM-dd').format(value);

                  Provider.of<Sessions>(context, listen: false)
                      .getSessionsForDay(
                          date.substring(0, 4),
                          date.substring(5, 7),
                          date.substring(8, 10),
                          filterBy);
                });
              },
            ),
          ),
          //Divider
          Container(
            margin: const EdgeInsets.all(10),
            child: Divider(
              color: Colors.grey,
              thickness: 2,
              indent: MediaQuery.of(context).size.width * 0.1,
              endIndent: MediaQuery.of(context).size.width * 0.1,
            ),
          ),
          // Number of patients and Picked day
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, top: 10, right: 15),
                child: Text(
                  DateFormat("EEEE d").format(
                    _selectedDate,
                    /*  (_selectedDate != null) ? _selectedDate : DateTime.now(), */
                  ),
                  style: const TextStyle(
                    fontFamily: 'lato',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: FutureBuilder(
                future: Provider.of<Sessions>(context, listen: false)
                    .getSessionsForDay(date.substring(0, 4),
                        date.substring(5, 7), date.substring(8, 10), filterBy),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(4),
                        itemBuilder: (context, index) {
                          return ShimmerWidgets.schedulePatientCardShimmer();
                        },
                        itemCount: 2,
                      ),
                    );
                  } else {
                    if (snapshot.data['error'] == null) {
                      return
                          // Sessions List for the day
                          ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: snapshot.data['data'].length,
                              itemBuilder: (context, index) {
                                return SchedulePatinetCard(
                                  doctorName: snapshot.data['data'][index]
                                      ['full_name'],
                                  userType: userType,
                                  imageUrl: snapshot.data['data'][index]
                                      ['profile_image'],
                                  name: snapshot.data['data'][index]
                                          ['first_name'] +
                                      " " +
                                      snapshot.data['data'][index]['last_name'],
                                  time: snapshot.data['data'][index]
                                      ['session_date'],
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        PatinetSessionsScreen.routeName,
                                        arguments: snapshot.data['data'][index]
                                            ['id']);
                                  },
                                );
                              });
                    } else {
                      return Center(
                        child: Text('No Sessions For This Day'.tr(context)),
                      );
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget buildAppBarFilter(date) {
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
          },
          icon: const Icon(Icons.filter_list),
        );
      },
    );
  }
}
