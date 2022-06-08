import 'package:flutter/material.dart';

class BottomDecoration extends StatelessWidget {
  const BottomDecoration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.0,
      child: BottomAppBar(
        color: const Color(0xFF4f42ed),
        child: Center(
            child: Container(
          padding: const EdgeInsets.only(top: 10.0),
          width: 80.0,
          child: const Divider(
            color: Colors.white,
            thickness: 2,
          ),
        )),
      ),
    );
  }
}
