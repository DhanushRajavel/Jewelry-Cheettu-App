import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'myFlutterIcon.dart';

TextStyle kWelcomeTextStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
          color: Color(0xFF8B8B8B), fontSize: 18, fontWeight: FontWeight.w300));
}

TextStyle kSplashScreenStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
          fontSize: 28, color: Color(0xFF7555DC), fontWeight: FontWeight.bold));
}

TextStyle kBodyTextStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ));
}

TextStyle kCardTitleTextStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300));
}

TextStyle kCardBodyTextStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white));
}

TextStyle kAppTitleTextStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4E4E4E)));
}

TextStyle kMyPlanTitlesTextStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
          fontSize: 16, color: Color(0xFF4E4E4E), fontWeight: FontWeight.w500));
}

TextStyle kPaymentTitleTextStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF4E4E4E)));
}

TextStyle kPaymentBodyTextStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF8B8B8B)));
}

TextStyle kMyPlanBodyTextStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300));
}

TextStyle kColumnTestStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w400, color: Colors.white));
}

TextStyle kRowTestStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF4E4E4E)));
}

TextStyle kAuthTitleStyle() {
  return GoogleFonts.poppins(
      textStyle: const TextStyle(
    fontSize: 20,
    color: Color(0xFF4E4E4E),
    fontWeight: FontWeight.w600,
  ));
}

const kTextFieldStyle = InputDecoration(
    prefixIcon: Icon(
      MyFlutterApp.joinplan,
      color: Color(0xFF4E4E4E),
      size: 24,
    ),
    hintText: "Your Name",
    hintStyle: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w300, color: Color(0xFF4E4E4E)),
    labelText: "Name",
    labelStyle: TextStyle(fontSize: 14, color: Color(0xFF8B8B8B)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFFD7D7D7), width: 2)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFFD7D7D7), width: 2)));
