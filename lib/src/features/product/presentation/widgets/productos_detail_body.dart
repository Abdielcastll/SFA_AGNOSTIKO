import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewProductDetailsBody extends StatelessWidget {
  final Widget topSection;
  final Widget middleSection;
  final Widget bottomSection;

  const NewProductDetailsBody({
    Key? key,
    required this.topSection,
    required this.middleSection,
    required this.bottomSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          topSection,
          middleSection,
          bottomSection,
        ],
      ),
    );
  }
}
