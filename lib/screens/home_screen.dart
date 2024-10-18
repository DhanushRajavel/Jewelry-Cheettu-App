import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:sms/components/profile_card.dart';
import 'package:sms/components/reusable_alert_box.dart';
import 'package:sms/constants.dart';
import 'package:sms/components/icon_buttons.dart';
import 'package:sms/myFlutterIcon.dart';
import 'package:sms/screens/help_screen.dart';
import 'package:sms/screens/join_plan_screen.dart';
import 'package:sms/screens/multi_product_screen.dart';
import 'package:sms/screens/my_profile.dart';
import 'package:sms/screens/transaction_screen.dart';
import 'package:sms/screens/my_plan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static final String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  Map<String, dynamic>? dashboardData;
  List<dynamic>? basicDetails;
  bool isLoading = true;
  String? imageUrl;
  String? planId;
  String? paidAmount;
  String? balanceAmount;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('name') ?? 'User';
    final accessToken = prefs.getString('accessToken');
    imageUrl = prefs.getString('photo') ?? 'https://shorturl.at/lQi0s';
    if (accessToken != null) {
      await _fetchDashboardData(accessToken);
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchDashboardData(String accessToken) async {
    try {
      final response = await ApiService.userDataPostMethod(
        authorization: accessToken,
        endPoint: '/p1-dashboard',
      );

      final basicDashboardData = await ApiService.userDataGetMethod(
        authorizationToken: "",
        endPoint: "/p1-basic-details",
      );

      if (response.containsKey('error')) {
        print('Error fetching dashboard data: ${response['error']}');
      } else {
        setState(() {
          dashboardData = response['data'];
          if (basicDashboardData!['response']['rules_en'] is List) {
            basicDetails = basicDashboardData['response']['rules_en'];
          } else {
            print(
                "Expected a List but got ${basicDashboardData['response']['rules_en'].runtimeType}");
          }

          isLoading = false;
        });
      }
    } catch (e) {
      print('Exception caught during _fetchDashboardData: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: _buildAppBar(),
      body: isLoading ? _buildLoading() : _buildContent(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          _buildProfileImage(),
          const SizedBox(width: 12.0),
          _buildWelcomeText(),
          const SizedBox(width: 50.0),

          const Spacer(),
          IconButton(
            onPressed: () {
              if (basicDetails != null && basicDetails!.isNotEmpty) {
                String rulesText = basicDetails!.map((rule) {
                  if (rule is Map<String, dynamic> &&
                      rule.containsKey('tm_text')) {
                    return rule['tm_text'];
                  }
                  return '';
                }).join('\n');
                ReusableAlertBox(
                  title: 'Rules',
                  content: rulesText, // Display all rules as a string
                ).show(context);
              } else {
                ReusableAlertBox(
                  title: 'Error',
                  content: 'No rules data available.',
                ).show(context);
              }
            },
            icon: const Icon(
              Icons.help,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        '$imageUrl',
        width: 48.0,
        height: 48.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome! 👋', style: kWelcomeTextStyle()),
        Text(userName ?? 'Loading...', style: kBodyTextStyle()),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileCard(
            userName: userName ?? 'User',
            imageUrl: imageUrl ?? 'https://shorturl.at/lQi0s',
            planID: dashboardData?['plan_id'] ?? 'ID001',
            paidAmount: '${dashboardData?['total_paid']}',
            balanceAmount: dashboardData?['balance_amount'] ?? '0.0',
          ),
          const SizedBox(height: 20),
          _buildIconButtonsContainer(),
          const SizedBox(height: 20),
          if (dashboardData != null) _buildBannerImage(),
        ],
      ),
    );
  }

  Widget _buildIconButtonsContainer() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButtonsRow([
            _buildIconButton(
                'Join Plan', MyFlutterApp.joinplan, JoinPlanScreen.id),
            _buildIconButton('My Plans', MyFlutterApp.myplans, MyPlanScreen.id),
            _buildIconButton(
                'Multi Product', Icons.more, MultiProductScreen.id),
          ]),
          _buildIconButtonsRow([
            _buildIconButton('My Profile', Icons.person, MyProfile.id),
            _buildIconButton(
                'Transaction', MyFlutterApp.transaction, TransactionScreen.id),
            _buildIconButton('Help', Icons.support_agent, HelpScreen.id),
          ]),
        ],
      ),
    );
  }

  Widget _buildIconButtonsRow(List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: buttons.map((button) => Expanded(child: button)).toList(),
    );
  }

  Widget _buildIconButton(String title, IconData icon, [String? route]) {
    return IconButtons(
      tilte: title,
      iconData: icon,
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
    );
  }

  Widget _buildBannerImage() {
    return Card(
      elevation: 2,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ImageSlideshow(
          initialPage: 0,
          indicatorRadius: 5,
          indicatorColor: Color(0xFF9177E3),
          indicatorBackgroundColor: Color(0xFFF1EEFC),
          isLoop: true,
          autoPlayInterval: 3000,
          children: dashboardData?['banners']
                  .map<Widget>((banner) =>
                      Image.network(banner['photo'], fit: BoxFit.fill))
                  .toList() ??
              [
                Image.asset('images/banner1.png', fit: BoxFit.cover),
              ],
        ),
      ),
    );
  }
}
