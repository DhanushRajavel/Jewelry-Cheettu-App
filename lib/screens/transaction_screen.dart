import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/my_bills_card.dart';
import 'package:sms/components/reusable_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/services/api_service.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});
  static final String id = 'transaction_screen';
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool isLoading = true;
  List<dynamic>? getTransactionData;
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
    final response = await ApiService.userDataGetMethod(
        authorizationToken: accessToken, endPoint: '/p1-mytransaction');
    if (response!.containsKey('error')) {
      print('Error fetching dashboard data: ${response['error']}');
    } else {
      setState(() {
        getTransactionData = response['response']['all_trx'];
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
      backgroundColor:const  Color(0xFFF7F7F7),
      appBar: const ReusableAppBar(title: 'My Bills'),
      body: isLoading
          ? _buildLoading()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 88,
                      decoration: BoxDecoration(
                          color: Color(0xFFE6FAF7),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF00CCAA),
                            radius: 28,
                            child: Icon(
                              Icons.payments,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Paid Amount',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFF4E4E4E),
                                  ),
                                ),
                              ),
                              Text(
                                '₹ ${getTransactionData?[0]['amount']?.toString() ??
                                    'No Data'}',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4E4E4E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    if (getTransactionData != null)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: getTransactionData?.length ?? 0,
                        itemBuilder: (context, index) {
                          final bill = getTransactionData?[index];
                          return Column(
                            children: [
                              MyBillsCard(
                                imageUrl: bill?['trx_photo'] ?? '',
                                planName: bill?['plan_name'] ?? 'No Plan Name',
                                transactionDate:
                                    bill?['created_at_tx'] ?? 'No Date',
                                amountPaid: bill?['amount']?.toString() ?? '0',
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      )else const Center(child: Text('No Bills Available'),)
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
