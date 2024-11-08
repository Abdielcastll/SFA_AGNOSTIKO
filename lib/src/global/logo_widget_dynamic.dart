import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

class LogoFromFirebase extends StatefulWidget {
  const LogoFromFirebase({super.key});

  @override
  State<LogoFromFirebase> createState() => _LogoFromFirebaseState();
}

class _LogoFromFirebaseState extends State<LogoFromFirebase> {
  Future<String?> fetchDownloadLink() async {
    String? filePath = globalRemoteConfig.refLogo!;
    String? downloadUrl = await getDownloadUrl(filePath);

    if (downloadUrl != null) {
      print('Download URL: $downloadUrl');
      return downloadUrl;
    } else {
      print('Failed to retrieve download URL');
      return null;
    }
  }

  Future<String?> getDownloadUrl(String filePath) async {
    try {
      // Reference the file in Firebase Storage using the provided file path
      String downloadUrl =
          await FirebaseStorage.instanceFor(app: multitenantConfig.tenantApp!)
              .ref(filePath)
              .getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error fetching download URL: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: fetchDownloadLink(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while fetching the URL
        } else if (snapshot.hasError) {
          return const Text('Error loading logo'); // Handle errors gracefully
        } else if (snapshot.hasData && snapshot.data != null) {
          return Image.network(
            snapshot.data!,
            fit: BoxFit.contain, // Adjust the fit as needed
          );
        } else {
          return const Text('No logo available'); // Handle null data
        }
      },
    );
  }
}
