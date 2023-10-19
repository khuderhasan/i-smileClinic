import 'package:flutter/material.dart';
import '../../core/constatnts.dart';
import '../../screens/patients_screens/priview_image.dart';

class ZoomImage extends StatelessWidget {
  final String imageUrl;
  final String title;
  const ZoomImage({super.key, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text("Title :   $title"),
        ),
        const Divider(
          indent: 30,
          endIndent: 30,
          thickness: 2,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(PriviewImage.routeName,
                arguments: {"imageUrl": imageUrl});
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            child: AspectRatio(
              aspectRatio: 1.7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(fit: BoxFit.cover, "$baseUrl/$imageUrl"),
              ),
            ),
          ),
        ),
        Divider(
          thickness: 3,
          color: Colors.grey[700],
        ),
      ],
    );
  }
}
