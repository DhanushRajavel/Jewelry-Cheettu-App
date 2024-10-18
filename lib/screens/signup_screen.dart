import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/components/call_to_action.dart';
import 'package:sms/components/reusable_button.dart';
import 'package:sms/components/reusable_alert_box.dart';
import 'package:sms/constants.dart';
import 'package:sms/screens/login_screen.dart';
import 'package:sms/services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static final String id = 'signup_screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool passwordVisible = true;
  
  // Controllers for input fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when no longer needed
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 92),
        child: Column(
          children: [
            Image.asset('images/logo.png'),
            const SizedBox(height: 16),
            Text('Jewelry App', style: kAuthTitleStyle()),
            const SizedBox(height: 24),
            Text('Please fill information below', style: kPaymentBodyTextStyle()),
            const SizedBox(height: 24),
            _buildFormFields(),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
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
              title: 'Sign Up',
              onPress: _registerUser,
            ),
            const SizedBox(height: 80),
            CallToAction(
              docs: 'Have an Account? ',
              title: 'Login',
              onPress: () {
                Navigator.pushNamed(context, LoginScreen.id);
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
        _buildTextField(
          controller: fullNameController,
          hintText: 'Full Name',
          labelText: 'Full Name',
          prefixIcon: Icons.account_balance,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: emailController,
          hintText: 'Email',
          labelText: 'Email',
          prefixIcon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: phoneNumberController,
          hintText: 'Phone Number',
          labelText: 'Phone Number',
          prefixIcon: Icons.phone_rounded,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: !passwordVisible,
      decoration: kTextFieldStyle.copyWith(
        hintText: 'Password',
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? labelText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: kTextFieldStyle.copyWith(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
      ),
    );
  }

  Future<void> _registerUser() async {
    final fullName = fullNameController.text;
    final email = emailController.text;
    final phoneNumber = phoneNumberController.text;
    final password = passwordController.text;

    if ([fullName, email, phoneNumber, password].any((element) => element.isEmpty)) {
      ReusableAlertBox(
        title: 'Error',
        content: 'All fields are required.',
      ).show(context);
      return;
    }

    try {
      final response = await ApiService.registerUser(
        name: fullName,
        email: email,
        password: password,
        mobile: phoneNumber,
        authorization: "",
        endPoint: '/p1-user-register'
      );

      if (response['status'] == 0) {
        ReusableAlertBox(
          title: 'Registration Failed',
          content: response['error'] ?? 'Registration failed. Please try again.',
        ).show(context);
      } else {
        ReusableAlertBox(
          title: 'Thank you!',
          content: 'Registration successful!',
          onPress: () => Navigator.pushNamed(context, LoginScreen.id),
        ).show(context);
      }
    } catch (e) {
      ReusableAlertBox(
        title: 'Error',
        content: 'Registration failed. Please try again later.',
      ).show(context);
    }
  }
}
