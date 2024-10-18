import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/components/my_plan_card.dart';
import 'package:sms/components/reusable_app_bar.dart';
import 'package:sms/constants.dart';
import 'package:sms/myFlutterIcon.dart';
import 'package:sms/services/api_service.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.planSchemeId});
  final String planSchemeId;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic>? myPlanDataDetails;
  List<dynamic>? allTransactions; // Store transactions separately
  bool isLoading = true;
  late String planSchemeId;

  @override
  void initState() {
    super.initState();
    planSchemeId = widget.planSchemeId;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      await _fetchDashboardData(accessToken, planSchemeId);
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchDashboardData(
      String accessToken, String planSchemeId) async {
    try {
      final response = await ApiService.planDetails(
        authorization: accessToken,
        endPoint: '/p1-plan_details',
        planId: planSchemeId, // Updated parameter name
      );

      if (response.containsKey('error')) {
        print('Error fetching dashboard data: ${response['error']}');
      } else {
        setState(() {
          myPlanDataDetails =
              response['response']['user_scheme']; // Plan details
          allTransactions = response['response']['all_trx']; // Transactions
        });
      }
    } catch (e) {
      print('Exception caught: $e');
    } finally {
      setState(() {
        isLoading = false; // Stop loading in all cases
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ReusableAppBar(title: 'Plan Details'),
      body: isLoading
          ? _buildLoading()
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildPlanDetails(), // Function to handle UI
                  if (allTransactions != null && allTransactions!.isNotEmpty)
                    _buildStyledDataTable()
                  else
                    const Center(
                      child: Text('No Trnaction Available'),
                    )
                ],
              ),
            ),
    );
  }

  // Method to display the fetched plan details
  Widget _buildPlanDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            myPlanDataDetails?['plan_name'] ?? 'Plan Name Unavailable',
            style: kPaymentTitleTextStyle(),
          ),
          Text(
            'Plan ID : ${myPlanDataDetails?['plan_id'] ?? 'ID Unavailable'}',
            style: kPaymentBodyTextStyle(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              MyPlanCard(
                bgColor: const Color(0xFFE6FAF7),
                iconData: MyFlutterApp.amount,
                iconBgColor: const Color(0xFF00CCAA),
                title: 'Total Amount',
                number: '₹ ${myPlanDataDetails?['total_amount'] ?? '0'}',
              ),
              const SizedBox(width: 8),
              MyPlanCard(
                bgColor: const Color(0xFFFFECEC),
                iconData: MyFlutterApp.scale,
                iconBgColor: const Color(0xFFFF4141),
                title: 'Total Grams',
                number: '${myPlanDataDetails?['total_grams'] ?? '0'}.00G',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildPaymentFields(
              'Name', myPlanDataDetails?['name'] ?? 'Unavailable'),
          const SizedBox(height: 16),
          _buildPaymentFields(
              'Months', myPlanDataDetails?['plan_date'] ?? 'Unavailable'),
          const SizedBox(height: 16),
          _buildPaymentFields('Group Code', 'NIF'),
          const SizedBox(height: 16),
          _buildPaymentFields('Membership No',
              myPlanDataDetails?['membership_no'] ?? 'Unavailable'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // Widget to build payment fields
  Widget _buildPaymentFields(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              title,
              style: kPaymentTitleTextStyle(),
            ),
            Spacer(),
            Text(
              value,
              style: kMyPlanBodyTextStyle(),
            )
          ],
        ),
        const SizedBox(height: 16),
        const Divider(
          thickness: 1,
          color: Color(0xFFD7D7D7),
        ),
      ],
    );
  }

  // Function to build DataTable rows
  List<DataRow> _buildDataRows() {
    if (allTransactions == null || allTransactions!.isEmpty) {
      return [];
    }

    return allTransactions!.map<DataRow>((transaction) {
      return DataRow(
        cells: [
          DataCell(
            Text(transaction['created_at_tx'] ?? 'No Date',
                style: kRowTestStyle()), // Transaction date
          ),
          DataCell(
            Text(transaction['installment']?.toString() ?? '0',
                style: kRowTestStyle()), // Installment number
          ),
          DataCell(
            Text(transaction['order_id'] ?? 'No Order ID',
                style: kRowTestStyle()), // Order ID
          ),
          DataCell(
            Text('\$${transaction['amount']?.toString() ?? '0'}',
                style: kRowTestStyle()), // Amount paid
          ),
        ],
      );
    }).toList();
  }

  // Widget to build the styled DataTable
  Widget _buildStyledDataTable() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Rounded corners
        color: Color(0xFFF7F7F7), // Background color for the table
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Slight shadow
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => const Color(0xFF7B3FE4), // Purple header color
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          columns: <DataColumn>[
            DataColumn(
              label: Text('Date', style: kColumnTestStyle()),
            ),
            DataColumn(
              label: Text('Inst.', style: kColumnTestStyle()),
            ),
            DataColumn(
              label: Text('Rect No.', style: kColumnTestStyle()),
            ),
            DataColumn(
              label: Text('Amount', style: kColumnTestStyle()),
            ),
          ],
          rows: _buildDataRows(),
        ),
      ),
    );
  }
}
