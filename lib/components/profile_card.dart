import 'package:flutter/material.dart';
import 'package:sms/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {required this.userName,
      required this.planID,
      required this.imageUrl,
      required this.paidAmount,
      required this.balanceAmount});
  final String userName;
  final String planID;
  final String balanceAmount;
  final String paidAmount;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 178,
      decoration: BoxDecoration(
        color: Color(0xFF9177E3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        '$imageUrl',
                        width: 48.0,
                        height: 48.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userName}',
                          style: kBodyTextStyle().copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 23),
                        ),
                        Text(
                          'Plan ID : $planID',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300)),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text('Paid Amount', style: kCardTitleTextStyle()),
                  Text(
                    '${'₹$paidAmount'}',
                    style: kCardBodyTextStyle(),
                  )
                ],
              ),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              Column(
                children: [
                  Text('Balance Amount', style: kCardTitleTextStyle()),
                  Text('${'₹$balanceAmount'}', style: kCardBodyTextStyle())
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
