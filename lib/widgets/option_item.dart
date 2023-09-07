import 'package:flutter/material.dart';

class OptionItem extends StatelessWidget {
  final String title;
  final Icon icon;

  Function onTap;

  OptionItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  void onSelected() {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            Text(
              title,
              style: const TextStyle(
                  color: Colors.blue,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
