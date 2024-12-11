import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/material.dart';

class PinpadManager {
  static final PinpadManager _instance = PinpadManager._internal();

  PinpadManager._internal();

  factory PinpadManager() {
    return _instance;
  }

  bool _isConnected = false;

  /// Checks and ensures the connection with the pinpad.
  /// Retries the connection until successful.
  Future<bool> ensureConnected(BuildContext context) async {
    const int maxRetries = 5;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      String? serialNumber;

      try {
        // Safely attempt to get the serial number
        serialNumber = await getSerialNumber();
      } catch (e) {
        print("Error during getSerialNumber: $e");
        serialNumber = null; // Handle exception by setting result to null
      }

      if (serialNumber != null) {
        _isConnected = true;
        print("Pinpad is connected. Serial: $serialNumber");
        return true;
      } else {
        print(
            "Pinpad not connected. Attempting to reconnect... (${retryCount + 1}/$maxRetries)");

        try {
          await connectPinpad();
          await closeCardReader();
          await cancelEmvTransaction();
        } catch (e) {
          print("Error during connectPinpad: $e");
        }
      }

      // Optional: Show a loading dialog while retrying
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Connecting to pinpad..."),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 1)); // Delay between retries
      Navigator.pop(context); // Close the dialog

      retryCount++;
    }

    print("Failed to connect to the pinpad after $maxRetries retries.");
    return false;
  }

  Future<bool> isConnected() async {
    try {
      final serialNumber = await getSerialNumber();
      if (serialNumber != null) {
        _isConnected = true;
        print("Pinpad is connected. Serial: $serialNumber");
        return true;
      } else {
        _isConnected = false;
        print("Pinpad is not connected.");
        return false;
      }
    } catch (e) {
      _isConnected = false;
      print("Error during getSerialNumber: $e");
      return false;
    }
  }
}
