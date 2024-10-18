import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/my_plan_card.dart';
import 'package:sms/components/my_plan_payment_card.dart';
import 'package:sms/components/reusable_app_bar.dart';
import 'package:sms/constants.dart';
import 'package:sms/myFlutterIcon.dart';
import 'package:sms/screens/confirm_payment_screen.dart';
import 'package:sms/screens/details_screen.dart';
import 'package:sms/services/api_service.dart';

class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({
    super.key,
  });
  static final String id = 'my_plan_screen';
  @override
  State<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  bool isLoading = true;
  Map<String, dynamic>? myPlanData;
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
      final response = await ApiService.userDataPostMethod(
          authorization: accessToken, endPoint: '/p1-myplan');
      if (response.containsKey('error')) {
        print('Error fetching dashboard data: ${response['error']}');
      } else {
        setState(() {
          myPlanData = response['response'];
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: const ReusableAppBar(title: 'My Plans'),
      body: isLoading
          ? _buildLoading()
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'The total number of plans you’ve owned so far.',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF4E4E4E),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      MyPlanCard(
                        bgColor: Color(0xFFFFF3E6),
                        iconData: MyFlutterApp.myplans,
                        iconBgColor: Color(0xFFFF8800),
                        title: 'Total Number Plans',
                        number: '${myPlanData?['total_plans']}',
                      ),
                      SizedBox(width: 10),
                      MyPlanCard(
                        bgColor: Color(0xFFE6FAF7),
                        iconData: Icons.calendar_month_outlined,
                        iconBgColor: Color(0xFF00CCAA),
                        title: 'Due of This Month',
                        number: '${myPlanData?['current_due']}',
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  if (myPlanData?['user_schemes'] != null)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: myPlanData?['user_schemes']?.length ?? 0,
                      itemBuilder: (context, index) {
                        final plan = myPlanData?['user_schemes']?[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${plan['plan_name']}', // First plan's name
                              style: kMyPlanTitlesTextStyle(),
                            ),
                            Text(
                              'Plan ID: ${plan['plan_id']}', // First plan's ID
                              style: kMyPlanBodyTextStyle(),
                            ),
                            SizedBox(height: 16),
                            Card(
                              elevation: 3,
                              child: Container(
                                height: 156,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    children: [
                                      MyPlanPaymentCard(
                                        title: 'Maturity',
                                        body:
                                            plan['maturity_date'] ?? 'No Date',
                                        buttonTitle: 'Detail',
                                        buttonBgColor: Color(0xFFF1EEFC),
                                        buttonTitleColor: Color(0xFF7555DC),
                                        onPress: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsScreen(
                                                planSchemeId:
                                                    plan?['membership_no'],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: 311,
                                        child: Divider(
                                          thickness: 1,
                                        ),
                                      ),
                                      MyPlanPaymentCard(
                                        title: 'Pending',
                                        body:
                                            '\$${plan['pending_amount'] ?? '0.00'}',
                                        buttonTitle: 'Pay',
                                        buttonBgColor: Color(0xFF7555DC),
                                        buttonTitleColor: Colors.white,
                                        onPress: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfirmPaymentScreen()));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
