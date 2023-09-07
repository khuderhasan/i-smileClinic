import 'package:flutter/material.dart';
import 'package:i_smile_clinic/core/constatnts.dart';

class PriviewImage extends StatelessWidget {
  static const routeName = "/priview-image";
  const PriviewImage({super.key});

  @override
  Widget build(BuildContext context) {
    final routArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String?>;
    final imageUrl = routArgs['imageUrl'];
    return Stack(
      fit: StackFit.expand,
      children: [
        InteractiveViewer(
          clipBehavior: Clip.none,
          child: Image.network("$baseUrl\\$imageUrl"),
        )
      ],
    );
  }
}
