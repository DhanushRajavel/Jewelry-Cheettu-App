import 'package:flutter/material.dart';
import 'package:sms/constants.dart';

class ResuableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? iconData;
  const ResuableAppBar({required this.title, this.iconData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(title, style: kAppTitleTextStyle()),
      actions: [
        Container(
          padding: EdgeInsets.only(left: 16),
          child: Icon(iconData),
        )
      ],
      centerTitle: true,
      scrolledUnderElevation: 0.0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
