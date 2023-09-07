import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidgets {
  static Shimmer schedulePatientCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(5.0),
          leading: const Icon(
            Icons.account_circle,
            size: 50,
            color: Colors.white,
          ),
          title: Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
            height: 10.0,
            color: Colors.white,
          ),
          subtitle: Row(
            children: [
              const Icon(
                Icons.watch_later_outlined,
                color: Colors.white,
              ),
              /*  const SizedBox(
                width: 5,
              ), */
              Expanded(
                child: Container(
                  height: 10.0,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Shimmer patientCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          leading: const Icon(
            Icons.account_circle,
            size: 50,
            color: Colors.white,
          ),
          title: Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
            height: 10.0,
            color: Colors.white,
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Container(
                  height: 10.0,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Shimmer sessionCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          leading: const Icon(
            Icons.medical_services_outlined,
            size: 30,
            color: Colors.white,
          ),
          title: Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
            height: 10.0,
            color: Colors.white,
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Container(
                  height: 10.0,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Shimmer profileImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: FittedBox(
        fit: BoxFit.none,
        child: CircleAvatar(
          radius: 70,
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: Container(
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
