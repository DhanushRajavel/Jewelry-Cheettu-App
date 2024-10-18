import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/reusable_alert_box.dart';
import 'package:sms/components/reusable_app_bar.dart';
import 'package:sms/components/reusable_plan_card.dart';
import 'package:sms/services/api_service.dart';

class JoinPlanScreen extends StatefulWidget {
  const JoinPlanScreen({super.key});
  static final String id = 'join_plan_screen';

  @override
  State<JoinPlanScreen> createState() => _JoinPlanScreenState();
}

class _JoinPlanScreenState extends State<JoinPlanScreen> {
  bool isLoading = true;
  List<dynamic>? joinPlanData;
  List<dynamic>? rulesData; // Stores the rules data

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

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
      // Fetch the plans
      final response = await ApiService.userDataGetMethod(
          authorizationToken: accessToken, endPoint: '/p1-all-plan');
      
      // Fetch the basic details (rules)
      final basicDetailsResponse = await ApiService.userDataGetMethod(
          authorizationToken: accessToken, endPoint: '/p1-basic-details');

      if (response != null && basicDetailsResponse != null) {
        setState(() {
          joinPlanData = response['response'];
          if (basicDetailsResponse['response']['rules_en'] is List) {
            rulesData = basicDetailsResponse['response']['rules_en'];
            _showRulesAlert(); // Show the rules alert
          }
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showRulesAlert() {
    if (rulesData != null && rulesData!.isNotEmpty) {
      String rulesText = rulesData!.map((rule) {
        if (rule is Map<String, dynamic> && rule.containsKey('tm_text')) {
          return rule['tm_text'];
        }
        return '';
      }).join('\n');

      ReusableAlertBox(
        title: 'Rules',
        content: rulesText,
      ).show(context);
    } else {
      ReusableAlertBox(
        title: 'Error',
        content: 'No rules data available.',
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: const ReusableAppBar(title: 'Join Plan'),
      body: isLoading ? _buildLoading() : _buildBodyContent(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBodyContent() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: makeCards(),
      ),
    );
  }

  Column makeCards() {
    if (joinPlanData == null || joinPlanData!.isEmpty) {
      return const Column(
        children: [
          Text(
            'No plans available.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    List<Widget> reusableCards = [];
    for (int i = 0; i < joinPlanData!.length; i++) {
      final plan = joinPlanData![i];
      reusableCards.add(
        ReusablePlanCard(
          title: plan['plan_name_en'] ?? 'No Title', // Check for null title
          bgImageUrl: plan['plan_banner_en'] ?? '', // Check for null image URL
          onPress: () {
            _registerPlan('${plan['plan_id']}');
          },
        ),
      );
      if (i < joinPlanData!.length - 1) {
        reusableCards.add(const SizedBox(height: 16)); // Adds 16px space between cards
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: reusableCards,
    );
  }

  Future<void> _registerPlan(String planId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final userName = prefs.getString('name');
    final email = prefs.getString('email');
    final mobile = prefs.getString('mobile');
    
    try {
      final response = await ApiService.requestUser(
          name: '$userName',
          email: '$email',
          planId: planId,
          mobile: '$mobile',
          authorizationToken: '$accessToken');

      if (response['status'] == 0) {
        ReusableAlertBox(
          title: 'Registration Failed',
          content: response['error'] ?? 'Registration failed. Please try again.',
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
