import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.message}) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loading class
          Center(
            child: SpinKitChasingDots(
              color: myTheme.colorScheme.secondary,
              size: 50,
            ),
          ),
          const SizedBox(height: 40),
          Text('$message, por favor espere...'),
        ],
      ),
    );
  }
}
