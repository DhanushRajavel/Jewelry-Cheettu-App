import 'package:flutter/material.dart';
import 'package:sms/components/reusable_button.dart';
import 'package:sms/constants.dart';

class ReusableAlertBox extends StatelessWidget {
  final String title;
  final String content;
  final Function()? onPress;
  ReusableAlertBox({required this.title, required this.content , this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(); // A placeholder container, since build should return a widget.
  }

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          scrollable: true,
          titleTextStyle: kAppTitleTextStyle(),
          content: Text(content),
          actions: <Widget>[
            ResuableButton(
              title: 'Okey',
              onPress: onPress ?? (){
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
