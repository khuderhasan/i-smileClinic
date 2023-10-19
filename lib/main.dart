import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_localizations.dart';
import 'core/constatnts.dart';
import 'cubit/locale_cubit.dart';
import 'providers/assistants.dart';
import 'providers/doctors.dart';
import 'screens/dashboard_screens/assistants_screen.dart';
import 'screens/dashboard_screens/settings_screen.dart';
import 'screens/patients_screens/attached_files_screen.dart';
import 'screens/patients_screens/priview_image.dart';
import 'screens/auth_screen.dart';
import 'screens/patients_screens/medical_info_screen.dart';
import 'screens/dashboard_screens/time_settings_screen.dart';

import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'providers/auth.dart';
import 'providers/patients.dart';
import 'providers/sessions.dart';
import 'screens/patients_screens/all_patients_screen.dart';
import 'screens/dashboard_screens/home_screen.dart';
import 'screens/patients_screens/patient_sessions_screen.dart';
import 'screens/patients_screens/personal_info_screen.dart';
import 'screens/dashboard_screens/schedule_screen.dart';
import 'screens/dashboard_screens/stepper_screen.dart';
import 'widgets/splash_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleCubit>(
      create: (context) => LocaleCubit()..getSavedLanguage(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Doctors>(
              create: (_) => Doctors('', []),
              update: (context, auth, previousDoctors) => Doctors(auth.token,
                  (previousDoctors == null) ? [] : previousDoctors.doctors)),
          ChangeNotifierProxyProvider<Auth, Sessions>(
            create: (_) => Sessions([], ''),
            update: (context, auth, previousSessions) => Sessions(
                (previousSessions == null) ? [] : previousSessions.sessions,
                auth.token),
          ),
          ChangeNotifierProxyProvider<Auth, Patients>(
            create: (_) => Patients([], '', ''),
            update: (context, auth, previousPatients) => Patients(
                (previousPatients == null) ? [] : previousPatients.patients,
                auth.token,
                auth.userId),
          ),
          ChangeNotifierProxyProvider<Auth, Assistants>(
              create: (_) => Assistants(''),
              update: (context, auth, previousAssistant) =>
                  Assistants(auth.token))
        ],
        child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
          builder: (context, state) {
            return MaterialApp(
              locale: state.locale,
              // const Locale('ar'),
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (deviceLocale != null &&
                      deviceLocale.languageCode == locale.languageCode) {
                    return deviceLocale;
                  }
                }

                return supportedLocales.first;
              },
              debugShowCheckedModeBanner: false,
              theme: myTheme,
              home:
                  // auth.isAuth ? const HomeScreen() : const AuthScreen(),

                  AnimatedSplashScreen(
                      splash: const SplashWidget(),
                      centered: true,
                      splashIconSize: 300,
                      animationDuration: const Duration(seconds: 2),
                      splashTransition: SplashTransition.fadeTransition,
                      nextScreen: Consumer<Auth>(
                        builder: (context, auth, _) => auth.isAuth
                            ? const HomeScreen()
                            : const AuthScreen(),
                      )),
              routes: {
                HomeScreen.routeName: (context) => const HomeScreen(),
                AllPatientsScreen.routeName: (context) =>
                    const AllPatientsScreen(),
                MedicalInfoScreen.routeName: (context) =>
                    const MedicalInfoScreen(),
                PatinetSessionsScreen.routeName: (context) =>
                    const PatinetSessionsScreen(),
                PersonalInfoScreen.routeName: (context) => PersonalInfoScreen(),
                StepperScreen.routeName: (context) => const StepperScreen(),
                ScheduleScreen.routeName: (context) => const ScheduleScreen(),
                TimeSettingsScreen.routeName: (context) =>
                    const TimeSettingsScreen(),
                AuthScreen.routeName: (context) => const AuthScreen(),
                AssistantsScreen.routeName: (context) =>
                    const AssistantsScreen(),
                SettingsScreen.routeName: (context) => const SettingsScreen(),
                AttachedFilesScreen.routName: (context) =>
                    const AttachedFilesScreen(),
                PriviewImage.routeName: (context) => PriviewImage(),
              },
            );
          },
        ),
      ),
    );
  }
}
