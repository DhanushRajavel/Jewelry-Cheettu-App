import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CallToAction extends StatelessWidget {
  const CallToAction({super.key, required this.docs, required this.title , required this.onPress});
  final String docs;
  final String title;
  final Function() onPress;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$docs',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF8B8B8B)),
            )),
        TextButton(
            onPressed: onPress,
            child: Text(
              '$title',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7555DC))),
            ))
      ],
    );
  }
}
