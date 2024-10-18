import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/reusable_app_bar.dart';
import 'package:sms/components/reusable_alert_box.dart';
import 'package:sms/services/api_service.dart';

class MultiProductScreen extends StatefulWidget {
  const MultiProductScreen({super.key});
  static final String id = 'multi_product_screen';

  @override
  State<MultiProductScreen> createState() => _MultiProductScreenState();
}

class _MultiProductScreenState extends State<MultiProductScreen> {
  bool isLoading = true;
  List<dynamic>? getPlanData;

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      await _fetchDashboardData(accessToken);
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchDashboardData(String accessToken) async {
    try {
      final response = await ApiService.userDataGetMethod(
          authorizationToken: accessToken, endPoint: '/p1-list-product');
      if (response!.containsKey('error')) {
        print('Error fetching dashboard data: ${response['error']}');
      } else {
        setState(() {
          getPlanData = response['response'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ReusableAppBar(title: 'Join Plan'),
      backgroundColor: Colors.white,
      body: isLoading
          ? _buildLoading()
          : getPlanData == null
              ? Center(
                  child: Text('No Product Available'),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          itemCount: getPlanData!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            final product = getPlanData?[index];
                            return _buildProductCard(
                              product?['photo'] ?? '',
                              product?['title'] ?? 'No Title',
                              product?['price'] ?? '0',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildProductCard(String imageUrl, String productName, String price) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 106,
            width: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover, // Adjust image fitting
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.error), // Handle image errors
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                productName,
                style: GoogleFonts.poppins(fontSize: 14), // Reduced font size
                overflow: TextOverflow.ellipsis, // Prevent overflow
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4E4E4E)),
          ),
          ElevatedButton(
            onPressed: () {
              _registerPlan('May I Know the Details about this : $productName');
            },
            child: Text(
              'Join Now',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 14, // Reduced button font size
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize:
                  const Size(double.infinity, 36), // Adjusted button size
              backgroundColor: const Color(0xFF7555DC),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registerPlan(String planName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final userName = prefs.getString('name');
    final email = prefs.getString('email');
    final mobile = prefs.getString('mobile');
    try {
      final response = await ApiService.requestUser(
          name: '$userName',
          email: '$email',
          planId: planName,
          mobile: '$mobile',
          authorizationToken: '$accessToken');

      if (response['status'] == 0) {
        ReusableAlertBox(
          title: 'Registration Failed',
          content:
              response['error'] ?? 'Registration failed. Please try again.',
        ).show(context);
      } else {
        ReusableAlertBox(
          title: 'Thank you!',
          content: 'Registration successful!',
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
