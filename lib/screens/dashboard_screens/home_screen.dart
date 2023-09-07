import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:i_smile_clinic/core/app_localizations.dart';
import 'package:i_smile_clinic/providers/auth.dart';
import 'package:i_smile_clinic/screens/dashboard_screens/assistants_screen.dart';
import 'package:i_smile_clinic/screens/dashboard_screens/settings_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../animations/size_transition.dart';
import '../../core/constatnts.dart';
import '../../core/wave_clipper.dart';
import '../../providers/doctors.dart';
import '../../widgets/option_item.dart';
import '../patients_screens/all_patients_screen.dart';
import 'schedule_screen.dart';
import 'time_settings_screen.dart';
import 'stepper_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    final userType = Provider.of<Auth>(context, listen: false).userTyper;
    Provider.of<Doctors>(context, listen: false).getAllDoctors();
    double w = MediaQuery.of(context).size.width;
    int columnCount = 2;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.97),
      body: Column(
        children: [
          AppBar(
            backgroundColor: myBlue,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
          Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: screenHeight * 0.22,
                    color: myBlue,
                  ),
                ),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  color: myBlue,
                  height: screenHeight * 0.21,
                ),
              ),
              Positioned(
                top: screenHeight * 0.06,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "Dashboard".tr(context),
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Expanded(
              child: AnimationLimiter(
            child: GridView.count(
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 25,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.all(w / 38),
              crossAxisCount: columnCount,
              children: [
                AnimatedGridItem(
                    position: 1,
                    columnCount: columnCount,
                    child: OptionItem(
                      title: 'ViewPatients'.tr(context),
                      onTap: () {
                        Navigator.push(context,
                            SizeTransition1(const AllPatientsScreen()));
                        // Navigator.of(context)
                        //     .pushNamed(AllPatientsScreen.routeName);
                      },
                      icon: const Icon(
                        Icons.groups,
                        size: 50,
                        color: Colors.blueGrey,
                      ),
                    )),
                AnimatedGridItem(
                  position: 3,
                  columnCount: columnCount,
                  child: OptionItem(
                    title: 'Schedule'.tr(context),
                    onTap: () {
                      Navigator.push(
                          context, SizeTransition1(const ScheduleScreen()));
                      // Navigator.of(context).pushNamed(ScheduleScreen.routeName);
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      size: 50,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                (userType == UserType.Assistant)
                    ? AnimatedGridItem(
                        position: 2,
                        columnCount: columnCount,
                        child: OptionItem(
                          title: 'AddPatient'.tr(context),
                          onTap: () {
                            Navigator.push(context,
                                SizeTransition1(const StepperScreen()));
                            /* Navigator.of(context).pushNamed(StepperScreen.routeName); */
                          },
                          icon: const Icon(
                            Icons.person_add,
                            size: 50,
                            color: Colors.blueGrey,
                          ),
                        ),
                      )
                    : AnimatedGridItem(
                        position: 3,
                        columnCount: columnCount,
                        child: OptionItem(
                          title: 'Settings'.tr(context),
                          onTap: () {
                            Navigator.push(context,
                                SizeTransition1(const TimeSettingsScreen()));
                            // Navigator.of(context).pushNamed(ScheduleScreen.routeName);
                          },
                          icon: const Icon(
                            Icons.settings,
                            size: 50,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                (userType == UserType.Doctor)
                    ? AnimatedGridItem(
                        position: 4,
                        columnCount: columnCount,
                        child: OptionItem(
                          title: 'Assistants'.tr(context),
                          onTap: () {
                            Navigator.push(context,
                                SizeTransition1(const AssistantsScreen()));
                            // Navigator.of(context)
                            //     .pushNamed(AllPatientsScreen.routeName);
                          },
                          icon: const Icon(
                            Icons.person_search_sharp,
                            size: 50,
                            color: Colors.blueGrey,
                          ),
                        ))
                    : Container(),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class AnimatedGridItem extends StatelessWidget {
  AnimatedGridItem({
    Key? key,
    required this.columnCount,
    required this.child,
    required this.position,
  }) : super(key: key);

  final int columnCount;
  final int position;
  final OptionItem child;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
      position: position,
      duration: const Duration(milliseconds: 500),
      columnCount: columnCount,
      child: ScaleAnimation(
        duration: const Duration(milliseconds: 900),
        curve: Curves.fastLinearToSlowEaseIn,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}
