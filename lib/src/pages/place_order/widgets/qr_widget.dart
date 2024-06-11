import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  final Future<String> futureUrl;

  QrCodeWidget({required this.futureUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: futureUrl,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No URL provided'));
        } else {
          return Center(
            child: QrImageView(
              data: snapshot.data!,
              version: QrVersions.auto,
              size: 200.0,
            ),
          );
        }
      },
    );
  }
}
