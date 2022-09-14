// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
    required this.userName,
    required this.charge,
  }) : super(key: key);

  final String? userName;
  final String? charge;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 350,
        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            child: Icon(
              Icons.person,
              size: 40,
              color: myTheme.colorScheme.primary,
            ),
          ),
          title: Text(
            '$userName',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '$charge',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: Color(0xFF7D5070),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
