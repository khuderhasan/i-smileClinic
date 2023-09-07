import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Image.asset(
          'assets/images/logo.png',
        ),
      ),
    );
    // const SizedBox(height: 35),
    // const Text(
    //   'I Smile Clinic',
    //   style: TextStyle(
    //     fontSize: 30,
    //   ),
    // )
  }
}
