import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPlanCard extends StatelessWidget {
  MyPlanCard(
      {required this.bgColor,
      required this.iconData,
      required this.iconBgColor,
      required this.title,
      required this.number});
  final Color bgColor;
  final IconData iconData;
  final Color iconBgColor;
  final String title;
  final String number;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      height: 150,
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: iconBgColor,
            radius: 28,
            child: Icon(
              iconData,
              color: Colors.white,
              size: 30,
            ),
          ),
          Text(
            '$title',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Color(0xFF8B8B8B),
                    fontWeight: FontWeight.w300,
                    fontSize: 15)),
          ),
          Text(
            '$number',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF4E4E4E),
                    fontWeight: FontWeight.w500)),
          )
        ],
      ),
    ));
  }
}
