import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyBillsCard extends StatelessWidget {
  const MyBillsCard(
      {super.key,
      required this.imageUrl,
      required this.planName,
      required this.transactionDate,
      required this.amountPaid});
  final String imageUrl;
  final String planName;
  final String transactionDate;
  final String amountPaid;
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          height: 90,
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl, // Replace with your profile image asset
                  width: 56,
                  height: 56,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    planName,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4E4E4E),
                            fontWeight: FontWeight.w300)),
                  ),
                  Text(
                    transactionDate,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8B8B8B),
                            fontWeight: FontWeight.w300)),
                  )
                ],
              ),
              Spacer(),
              Text(
                '₹ $amountPaid',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF4E4E4E))),
              )
            ],
          ),
        ));
  }
}
