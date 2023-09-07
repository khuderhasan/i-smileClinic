import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);
  final Icon icon;
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 65,
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Row(
              children: [
                icon,
                const SizedBox(
                  width: 8,
                ),
                Text(title),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Text(value!),
          ],
        ),
      ),
    );
  }
}
