import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/responsive/dimensions.dart';

class Responsivelayout extends StatelessWidget {
  const Responsivelayout({
    Key? key,
    required this.mobileBody,
    required this.desktopBody,
  }) : super(key: key);

  final Widget mobileBody;
  final Widget desktopBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileWidth) {
          return mobileBody;
        } else {
          return desktopBody;
        }
      },
    );
  }
}
