import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/reusable_app_bar.dart';
import 'package:sms/components/reusable_button.dart';
import 'package:sms/components/reusable_alert_box.dart';
import 'package:sms/constants.dart';
import 'package:sms/screens/home_screen.dart';
import 'package:sms/services/api_service.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});
  static final String id = 'help_screen';

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  bool isLoading = true;
  String? accessToken;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  final TextEditingController _userMessageController = TextEditingController();

  String updatedName = '';
  String updatedEmail = '';
  String updatedMobile = '';

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _userMessageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('accessToken');
      updatedName = prefs.getString('name') ?? '';
      updatedEmail = prefs.getString('email') ?? '';
      updatedMobile = prefs.getString('mobile') ?? '';

      _fullNameController.text = updatedName;
      _emailController.text = updatedEmail;
      _phoneNumberController.text = updatedMobile;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReusableAppBar(title: 'Help'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Get in Touch', style: kAuthTitleStyle()),
                                const SizedBox(height: 24),
                                Text('We are always here to help you!',
                                    style: kPaymentBodyTextStyle()),
                                const SizedBox(height: 24),
                                _buildFormFields(),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildBottomButton(),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildBottomButton() {
    return Column(
      children: [
        const Divider(
          thickness: 1,
          color: Color(0xFFD7D7D7),
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 30),
          child: ResuableButton(
            title: 'Submit',
            onPress: () {
              _contactUser(
                updatedName,
                updatedMobile,
                updatedEmail,
                _userMessageController.text,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _fullNameController,
          hintText: 'Full Name',
          labelText: 'Full Name',
          prefixIcon: Icons.account_balance,
          onChanged: (value) {
            setState(() {
              updatedName = value;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          hintText: 'Email',
          labelText: 'Email',
          prefixIcon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            setState(() {
              updatedEmail = value;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _userMessageController,
          hintText: 'Enter your Queries',
          labelText: 'Message',
          prefixIcon: Icons.message,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? labelText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged, // Capture real-time changes
      keyboardType: keyboardType,
      decoration: kTextFieldStyle.copyWith(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
      ),
    );
  }

  Future<void> _contactUser(
    String userName,
    String userMobile,
    String userEmail,
    String userMessage,
  ) async {
    try {
      final response = await ApiService.requestUser(
        name: userName,
        email: userEmail,
        planId: userMessage,
        mobile: userMobile,
        authorizationToken: accessToken!,
      );

      if (response['status'] == 0) {
        ReusableAlertBox(
          title: 'Submission Failed',
          content: response['error'] ?? 'Submission failed. Please try again.',
        ).show(context);
      } else {
        ReusableAlertBox(
          title: 'Thank you!',
          content: 'Submission successful!',
          onPress: () {
            Navigator.pushNamed(context, HomeScreen.id);
          },
        ).show(context);
      }
    } catch (e) {
      ReusableAlertBox(
        title: 'Error',
        content: 'Submission failed. Please try again later.',
      ).show(context);
    }
  }
}
