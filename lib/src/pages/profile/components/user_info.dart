import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({
    Key? key,
    required this.userName,
    required this.charge,
  }) : super(key: key);

  final String? userName;
  final String? charge;

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 350,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            child: Icon(
              Icons.person,
              size: 40,
              color: themeProvider.myTheme.colorScheme.primary,
            ),
          ),
          title: Text(
            '${widget.userName}',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: themeProvider.myTheme.colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                '${widget.charge}',
                style: const TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: Color(0xFF7D5070),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
