import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/call_to_action.dart';
import 'package:sms/components/reusable_button.dart';
import 'package:sms/components/reusable_alert_box.dart';
import 'package:sms/constants.dart';
import 'package:sms/screens/home_screen.dart';
import 'package:sms/screens/signup_screen.dart';
import 'package:sms/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (phoneNumberController.text.isEmpty || passwordController.text.isEmpty) {
      ReusableAlertBox(
        title: 'Error',
        content: 'Please enter both phone number and password.',
      ).show(context);
      return;
    }

    try {
      final phoneNumber = phoneNumberController.text;
      final password = passwordController.text;
      final response = await ApiService.loginUser(
        mobile: phoneNumber,
        password: password,
      );

      if (response['status'] == 0) {
        ReusableAlertBox(
          title: 'Login Failed',
          content: 'Invalid phone number or password. Please try again.',
        ).show(context);
      } else {
        await saveUserData(response['data']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    } catch (e) {
      ReusableAlertBox(
        title: 'Error',
        content: 'Login failed. Please try again later.',
      ).show(context);
    }
  }

  Future<void> saveUserData(Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', data['name']);
    prefs.setString('phone', data['phone']);
    prefs.setString('email', data['email']);
    prefs.setString('photo', data['photo']);
    prefs.setString('accessToken', data['accesstoken']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 92),
              child: Column(
                children: [
                  Image.asset('images/logo.png'),
                  const SizedBox(height: 16),
                  Text(
                    'Jewelry App',
                    style: kAuthTitleStyle(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Please fill information below',
                    style: kPaymentBodyTextStyle(),
                  ),
                  const SizedBox(height: 24),
                  _buildFormFields(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Implement "Forgot Password" functionality if needed
                      },
                      child: Text(
                        'Forget Password',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7555DC),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ResuableButton(
                    title: 'Log In',
                    onPress: _loginUser,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            CallToAction(
              docs: 'Don’t have an account? ',
              title: 'Register',
              onPress: () {
                Navigator.pushNamed(context, SignupScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildTextField(
          controller: phoneNumberController,
          hintText: 'Phone Number',
          labelText: 'Phone Number',
          prefixIcon: Icons.phone_rounded,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: passwordController,
          hintText: 'Password',
          labelText: 'Password',
          prefixIcon: Icons.lock,
          obscureText: !passwordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: kTextFieldStyle.copyWith(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        labelText: labelText,
      ),
    );
  }
}
