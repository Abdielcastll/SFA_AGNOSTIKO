import 'package:flutter/material.dart';

class PoweredByAgnostiko extends StatelessWidget {
  const PoweredByAgnostiko({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset('assets/images/agnostiko.png'),
    );
  }
}
