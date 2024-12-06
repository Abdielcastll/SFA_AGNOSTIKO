import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
      return downloadUrl;
    } else {
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

  Future<File?> fetchLogoWithCache(String imageUrl) async {
    try {
      // Use DefaultCacheManager to fetch and cache the image
      final cacheManager = DefaultCacheManager();
      return await cacheManager.getSingleFile(imageUrl);
    } catch (e) {
      print('Error fetching logo with cache: $e');
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
          return Image.asset(
            "assets/images/Logo_FS _V_White.png",
          ); // error loading
        } else if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<File?>(
            future: fetchLogoWithCache(snapshot.data!),
            builder: (context, cacheSnapshot) {
              if (cacheSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show loading while fetching from cache
              } else if (cacheSnapshot.hasError) {
                return Image.asset(
                  "assets/images/Logo_FS _V_White.png",
                ); // error loading cache
              } else if (cacheSnapshot.hasData && cacheSnapshot.data != null) {
                return Image.file(
                  cacheSnapshot.data!,
                  fit: BoxFit.contain, // Adjust the fit as needed
                );
              } else {
                return Image.asset(
                  "assets/images/Logo_FS _V_White.png",
                ); // Handle no cache data
              }
            },
          );
        } else {
          return Image.asset(
            "assets/images/Logo_FS _V_White.png",
          ); // Handle null data
        }
      },
    );
  }
}
