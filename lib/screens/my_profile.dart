import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/reusable_alert_box.dart';
import 'package:sms/components/reusable_app_bar.dart';
import 'package:sms/components/reusable_button.dart';
import 'package:sms/constants.dart';
import 'package:sms/screens/home_screen.dart';
import 'package:sms/screens/login_screen.dart';
import 'package:sms/services/api_service.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  static final String id = 'my_profile';

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool isLoading = true;
  Map<String, dynamic>? userData;
  String? accessToken;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _userAddressController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _userAddressController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _userAddressController = TextEditingController();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      await _fetchProfileData(accessToken!);
    }
  }

  Future<void> _fetchProfileData(String accessToken) async {
    try {
      final response = await ApiService.userDataGetMethod(
        authorizationToken: accessToken,
        endPoint: '/p1-profile-details',
      );

      if (response != null && !response.containsKey('error')) {
        setState(() {
          userData = response['data'];
          _initializeFormFields(userData);
          isLoading = false;
        });
      } else {
        print('Error fetching profile data: ${response?['error']}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  void _initializeFormFields(Map<String, dynamic>? data) {
    _fullNameController.text = data?['user_name'] ?? '';
    _emailController.text = data?['email'] ?? '';
    _phoneNumberController.text = data?['phone_no'] ?? '';
    _userAddressController.text = data?['address'] ?? '';
  }

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _contactUser() async {
    try {
      final response = await ApiService.updateUserProfile(
        name: _fullNameController.text,
        email: _emailController.text,
        address: _userAddressController.text,
        mobile: _phoneNumberController.text,
        authorization: accessToken!,
      );

      if (response['status'] == 0) {
        _showAlert('Submission Failed', response['error'] ?? 'Please try again.');
      } else {
        _showAlert('Thank you!', 'Submission successful!', onPress: () {
          Navigator.pushNamed(context, HomeScreen.id);
        });
      }
    } catch (e) {
      _showAlert('Error', 'Submission failed. Please try again later.');
    }
  }

  void _showAlert(String title, String content, {VoidCallback? onPress}) {
    ReusableAlertBox(
      title: title,
      content: content,
      onPress: onPress,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const ReusableAppBar(title: 'My Profile'),
      body: isLoading ? _buildLoading() : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileAvatar(),
                const SizedBox(height: 32),
                _buildSectionTitle('Information'),
                const SizedBox(height: 16),
                _buildFormFields(),
                const SizedBox(height: 16),
                _buildLogoutButton(),
              ],
            ),
          ),
        ),
        _buildBottomButton(),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: const Color(0xFFFB0007),
            backgroundImage: userData?['photo'] != null
                ? NetworkImage(userData!['photo'])
                : const AssetImage('images/register_profile.png') as ImageProvider,
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.grey, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => _logout(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 24, color: Colors.white),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(0, 50),
          maximumSize: const Size(141, 50),
          backgroundColor: const Color(0xFF7555DC),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Column(
      children: [
        const Divider(thickness: 1, color: Color(0xFFD7D7D7)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: ResuableButton(title: 'Save', onPress: _contactUser),
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
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          hintText: 'Email',
          labelText: 'Email',
          prefixIcon: Icons.email_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneNumberController,
          hintText: 'Phone Number',
          labelText: 'Phone Number',
          prefixIcon: Icons.phone_rounded,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _userAddressController,
          hintText: 'Address',
          labelText: 'Address',
          prefixIcon: Icons.location_on,
          keyboardType: TextInputType.multiline,
        ),
      ],
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }
}
