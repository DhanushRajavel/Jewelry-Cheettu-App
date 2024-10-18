import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconButtons extends StatelessWidget {
  IconButtons({required this.tilte , required this.iconData , this.onTap});
  final String tilte;
  final IconData iconData;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFF1EEFC),
            radius: 36,
            child: Icon(
              iconData,
              size: 32,
              color: Color(0xFF7555DC),
            ),
          ),
          SizedBox(height: 8,),
          Text('$tilte',style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 16,
              color: Color(0xFF4E4E4E),
              fontWeight: FontWeight.w300
            )
          ),),
        ],
      ),
    );
  }
}
