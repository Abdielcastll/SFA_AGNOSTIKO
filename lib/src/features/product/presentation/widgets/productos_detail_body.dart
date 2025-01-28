import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 5),
      color: const Color.fromRGBO(240, 238, 251, 1),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: topSection,
          ),
          Expanded(
            flex: 7,
            child: middleSection,
          ),
          Expanded(
            flex: 3,
            child: bottomSection,
          ),
        ],
      ),
    );
  }
}
