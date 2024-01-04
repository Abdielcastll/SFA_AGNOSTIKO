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
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 300,
              child: Image.asset('assets/images/bimboPay.png')),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Divider(
                height: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
