import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/reusable_alert_box.dart';
import 'package:sms/components/reusable_app_bar.dart';
import 'package:sms/components/reusable_button.dart';
import 'package:sms/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:sms/screens/home_screen.dart';
import 'package:sms/services/api_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  static final String id = 'payment_screen';
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool value = false;
  bool isLoading = true;
  Map<String, dynamic>? shopInfo;
  File? _selectedImage; // This will hold the selected image
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance
  Future<void> _fetchPaymentScreenData() async {
    final response =
        await ApiService.userDataGetMethod(endPoint: '/p1-basic-details', authorizationToken: '');
    if (response!.containsKey('error')) {
      print('Error fetching dashboard data: ${response['error']}');
    } else {
      setState(() {
        shopInfo = response['response']['shop_info'];
        isLoading = false;
      });
    }
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Store selected image
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPaymentScreenData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReusableAppBar(title: 'Payment'),
      body: isLoading
          ? _buildLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildQRCodeSection(),
                    const SizedBox(height: 24),
                    _buildUploadSection(),
                    const SizedBox(height: 16),
                    _buildCheckboxSection(),
                    const SizedBox(height: 24),
                    _buildBankDetailCard(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: ResuableButton(
          title: 'Pay Now',
          onPress: () {
            if (value && _selectedImage != null) {
              _payNowButton();
            } else {
              ReusableAlertBox(
                title: 'Check Box or Image can\'t be empty',
                content:
                    'Please check the box and upload the payment receipt before submitting.',
              ).show(context);
            }
          },
        ),
      ),
    );
  }

  Future<void> _payNowButton() async {
  try {
    // Fetch the access token from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    // Check if accessToken or _selectedImage is null
    if (accessToken == null || _selectedImage == null) {
      ReusableAlertBox(
        title: 'Error',
        content: 'Missing access token or image. Please try again.',
      ).show(context);
      return; // Exit early if validation fails
    }

    // Make the API request to confirm the payment
    final response = await ApiService.confirmPayment(
      authorization: accessToken,
      endPoint: '/p1-confirm_payment',
      planId: 'SM000003', // Make sure the parameter matches the method's named argument
      image: _selectedImage, // File object for the selected image
    );

    // Check the response for the specific message
    if (response['status'] == 0 && response['message'] == "Plz wait your last transaction is pending!") {
      ReusableAlertBox(
        title: 'Thank you!',
        content: 'Plz wait your last transaction is pending!',
        onPress: () {
          Navigator.pushNamed(context, HomeScreen.id);
        },
      ).show(context);
    } else {
      ReusableAlertBox(
        title: 'Submission Failed',
        content: response['error'] ?? 'Submission failed. Please try again.',
      ).show(context);
    }
  } catch (e) {
    // Handle any exceptions that may occur
    ReusableAlertBox(
      title: 'Error',
      content: 'Payment failed. Please try again later.',
    ).show(context);
  }
}


  Widget _buildQRCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 400,
          child: Image.network('${shopInfo?['payment_qr_code']}'),
        ),
        const SizedBox(height: 16),
        Text('Please Scan Here', style: kPaymentTitleTextStyle()),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Receipt',
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(height: 16),
        DottedBorder(
          strokeWidth: 3,
          color: const Color(0xFFD7D7D7),
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          padding: const EdgeInsets.all(16),
          dashPattern: const [6, 3],
          child: InkWell(
            onTap: _pickImage, // Open the gallery on tap
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.upload_file),
                const SizedBox(width: 8),
                Text(
                  'Upload',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8B8B8B)),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Display the selected image
        if (_selectedImage != null)
          Image.file(
            _selectedImage!,
            alignment: Alignment.center,
            height: 200,
            fit: BoxFit.cover,
          ),
      ],
    );
  }

  Widget _buildCheckboxSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            setState(() {
              value = newValue!;
            });
          },
        ),
        Expanded(
          child: Text(
            'Check payment receipt before submitting and our team will call you',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF8B8B8B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankDetailCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bank Details',
            style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF4E4E4E),
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          _buildBankDetail('A/C Name', shopInfo?['bank_ac_name'] ?? 'N/A'),
          _buildBankDetail('A/C No', shopInfo?['bank_ac_no'] ?? 'N/A'),
          _buildBankDetail('IFSC', shopInfo?['bank_ifc'] ?? 'N/A'),
          _buildBankDetail('Branch', shopInfo?['bank_branch'] ?? 'N/A'),
          _buildBankDetail('Bank Name', shopInfo?['bank_name'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildBankDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(title, style: kPaymentTitleTextStyle()),
          const Spacer(),
          Text(value, style: kPaymentBodyTextStyle()),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
