import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusablePlanCard extends StatelessWidget {
  const ReusablePlanCard({
    required this.title,
    required this.bgImageUrl,
    required this.onPress,
  });

  final String title;
  final String bgImageUrl;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(bgImageUrl), // Background image from URL
          fit: BoxFit.cover, // Cover entire container
        ),
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4E4E4E), // Text color for better contrast
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onPress,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B61FF), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'Join Now',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
