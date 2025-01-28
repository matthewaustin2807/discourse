import 'package:flutter/material.dart';

/// Color class to provide all colors utilized by the app
class AppColor {
  final Color buttonActive = const Color.fromRGBO(190, 154, 245, 100);
  final Color buttonInactive = Colors.grey;

  final Color inactiveBottomNavBar = Colors.black54;

  final Color primary = const Color.fromRGBO(185, 133, 254, 100);
  final Color secondary = const Color.fromRGBO(150, 103, 224, 100);
  final Color tertiary = const Color.fromRGBO(212, 187, 252, 100);
  final Color darkPurple = const Color.fromRGBO(69, 0, 176, 100);
  final Color lightPurple = Colors.purple.shade50;

  final Color textActivePrimary = Colors.black;
  final Color textActiveSecondary = Colors.white;
  final Color? textActiveTertiary = Colors.grey[600];
  final Color? textInactive = Colors.grey[350];
  final Color textError = Colors.red;

  final Color borderColor = Colors.black54;
  final Color tagColor = const Color.fromRGBO(242, 193, 243, 100);
  final Color separator = const Color.fromRGBO(208, 208, 208, 100);

  final Color discussionForumRoundedContainers =
      const Color.fromRGBO(217, 217, 217, 100);
  final Color discussionForumRoundedContainerBorder = Colors.black12;

  final Color? starColorPrimary = Colors.deepPurple[200];
  final Color? starColorSecondary = Colors.amberAccent[100];
}
