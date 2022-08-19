import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class BottomDecoration extends StatelessWidget {
  const BottomDecoration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0,
      child: BottomAppBar(
        color: myTheme.colorScheme.primary,
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 3.0),
            width: 80.0,
            child: Divider(
              color: myTheme.colorScheme.tertiary,
              thickness: 2,
            ),
          ),
        ),
      ),
    );
  }
}
