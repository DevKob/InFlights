import 'package:flutter/material.dart';

Color primary = const Color(0xff607da1);

class AppStyles{
  static Color primaryColor = primary;
  static Color bgColor = Color.fromRGBO(242, 240, 240, 0.973);
  static Color textColor = const Color(0xff3b3b3b);
  static Color ticketBlue = const Color(0xFF526799);
  static Color ticketRed = const Color(0xFFF37B67);
  static Color planeColor = const Color.fromARGB(255, 230, 231, 235);
  static Color btnSearch = const Color(0xD91130CE);
  static Color circleColor = const Color(0xFF189999);
  static Color orangeColor = const Color(0xFFEC6545);
  static Color ticketWhite = const Color(0xFFFFFFFF);
  static Color dotColor = const Color(0xFF8ACCF7);
  static Color planeSecondColor = const Color(0xFFBACCF7);
  static Color profileLocationColor = const Color(0xFFFEF4F3);
  static Color profileTextColor = const Color(0xFF526799);

  static TextStyle textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textColor);

  static TextStyle headLineStyle1 =  TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.bold,
  color: textColor);

  static TextStyle headLineStyle2 =  TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: textColor
  );

  static TextStyle headLineStyle4 =  TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: textColor,);


  static TextStyle headLineStyle3 =  TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      );
}