import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.message, this.duration})
      : super(key: key);

  final String? message;
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    print('DURATION ON LOADING WIDGET: $duration');
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loading class
          Center(
            child: SpinKitCircle(
              color: myTheme.colorScheme.primary,
              size: 50,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            '$message, por favor espere...',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
