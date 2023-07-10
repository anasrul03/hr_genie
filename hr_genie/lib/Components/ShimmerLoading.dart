import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_genie/Components/ShimmerLeaveApplication.dart';
import 'package:hr_genie/Components/ShimmerLeaveDetailsPage.dart';

import 'ShimmerLeavePage.dart';

class ShimmerLoading extends StatelessWidget {
  final String screenName;
  const ShimmerLoading({
    super.key,
    required this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    return loadByRouteName(screenName);
  }
}

Widget loadByRouteName(String screenName) {
  switch (screenName) {
    case "LEAVE":
      return const ShimmerLeavePage();
    case "LEAVE FORM":
      return const ShimmerLeaveApplication();
    case "LEAVE DETAILS":
      return const ShimmerLeaveDetailsPage();
    default:
      return const CircularProgressIndicator();
  }
}