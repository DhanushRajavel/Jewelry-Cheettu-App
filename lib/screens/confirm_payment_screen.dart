import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/components/reusable_app_bar.dart';
import 'package:sms/components/reusable_button.dart';
import 'package:sms/constants.dart';
import 'package:sms/screens/payment_screen.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  const ConfirmPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: const ReusableAppBar(title: 'Confirm Payment'),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset('images/confirm_payment.png'),
                ),
                Text(
                  '\$25.00',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4E4E4E))),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Review details of this transaction and enter confirm to proceed ',
                  style: kPaymentTitleTextStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24,
                ),
                _buildPaymentFields('Plan Name', 'Ring'),
                SizedBox(
                  height: 16,
                ),
                _buildPaymentFields('Plan ID', 'ID0012'),
                SizedBox(
                  height: 16,
                ),
                _buildPaymentFields('Group Code', 'NIF'),
                SizedBox(
                  height: 16,
                ),
                _buildPaymentFields('Membership No', '1024'),
                SizedBox(
                  height: 16,
                ),
                _buildPaymentFields('Installment', '05'),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 34,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Divider(
                thickness: 1,
                color: Color(0xFFD7D7D7),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: ResuableButton(
                    title: 'Pay Now',
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentScreen()));
                    }),
              )
            ],
          ),
        ],
      )),
    );
  }

  Widget _buildPaymentFields(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '$title',
              style: kPaymentTitleTextStyle(),
            ),
            Spacer(),
            Text(
              '$value',
              style: kMyPlanBodyTextStyle(),
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Divider(
          thickness: 1,
          color: Color(0xFFD7D7D7),
        ),
      ],
    );
  }
}