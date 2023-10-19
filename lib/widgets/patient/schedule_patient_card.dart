import 'package:flutter/material.dart';
import '../../core/constatnts.dart';

import 'package:intl/intl.dart';

import '../../providers/auth.dart';

class SchedulePatinetCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String time;
  final Function onTap;
  final UserType? userType;
  final String doctorName;

  const SchedulePatinetCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.time,
    required this.onTap,
    required this.userType,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(time);
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          leading: (imageUrl == null)
              ? const Icon(
                  Icons.account_circle,
                  size: 50,
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage("$baseUrl/$imageUrl")),
          title: Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Lato',
              ),
            ),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.watch_later_outlined),
              const SizedBox(
                width: 5,
              ),
              Text(
                DateFormat.jm().format(date),
                style: const TextStyle(fontSize: 13),
              )
            ],
          ),
          trailing: Text('Dr: $doctorName'),
        ),
      ),
    );
  }
}
