import 'package:flutter/material.dart';

class SelectedClientKiosko extends StatelessWidget {
  const SelectedClientKiosko({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            width: 400,
            child: Image.asset(
              'assets/images/placeholder_company.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Divider(
                color: Colors.grey,
                height: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
