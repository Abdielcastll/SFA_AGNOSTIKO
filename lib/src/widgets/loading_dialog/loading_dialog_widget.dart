import 'package:flutter/material.dart';

class LoadingDialogWidget extends StatelessWidget {
  const LoadingDialogWidget({Key? key, this.message}) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Progress Bar,
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 8),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Colors.pinkAccent,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('$message, por favor espere...'),
        ],
      ),
    );
  }
}
