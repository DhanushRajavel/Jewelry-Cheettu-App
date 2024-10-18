import 'package:flutter/material.dart';
import 'package:sms/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPlanPaymentCard extends StatelessWidget {
  MyPlanPaymentCard({
    required this.title,
    required this.body,
    required this.buttonTitle,
    required this.buttonBgColor,
    required this.buttonTitleColor,
    required this.onPress,
  });

  final String title;
  final String body;
  final String buttonTitle;
  final Color buttonTitleColor;
  final Color buttonBgColor;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: kMyPlanTitlesTextStyle(),
            ),
            Text(
              body,
              style: kMyPlanBodyTextStyle(),
            ),
          ],
        ),
        Spacer(),
        TextButton(
          onPressed: onPress,
          style: TextButton.styleFrom(
            minimumSize: Size(96, 36),
            backgroundColor: buttonBgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            buttonTitle,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: buttonTitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
