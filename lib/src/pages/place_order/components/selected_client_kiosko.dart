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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            height: 120,
            child: Image.asset(
              'assets/images/logo_prosa_color.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Divider(
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
