import 'dart:async';
import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/material.dart';

class PinpadManager {
  static final PinpadManager _instance = PinpadManager._internal();

  PinpadManager._internal();

  factory PinpadManager() {
    return _instance;
  }

  bool _isConnected = false;
  Timer? _connectionCheckTimer;

  /// Starts a periodic check for the pinpad connection.
  void startConnectionMonitoring({
    required BuildContext context,
    required Future<void> Function() onConnectionLost,
    Duration interval = const Duration(seconds: 2),
  }) {
    stopConnectionMonitoring(); // Ensure no duplicate timers
    print("Starting connection monitoring...");

    _connectionCheckTimer = Timer.periodic(interval, (_) async {
      print("Performing periodic pinpad connection check...");
      String? serialNumber = await getSerialNumber();
      print("serial: $serialNumber");
      if (serialNumber == null) {
        if (_isConnected) {
          print("Connection lost during monitoring! Serial number is null.");
          _isConnected = false;
          await onConnectionLost();
        } else {
          print("Pinpad still disconnected during monitoring.");
        }
      } else {
        if (!_isConnected) {
          print("Pinpad reconnected during monitoring. Serial: $serialNumber");
        }
        _isConnected = true;
      }
    });
  }

  /// Stops the periodic connection monitoring.
  void stopConnectionMonitoring() {
    if (_connectionCheckTimer != null) {
      print("Stopping connection monitoring...");
      _connectionCheckTimer!.cancel();
      _connectionCheckTimer = null;
    }
  }

  /// Reconnects to the pinpad if disconnected.
  Future<void> reconnect() async {
    print("Attempting to reconnect to the pinpad...");
    if (!_isConnected) {
      await connectPinpad();
      String? serialNumber = await getSerialNumber();
      _isConnected = serialNumber != null;

      if (_isConnected) {
        print("Reconnection successful. Serial: $serialNumber");
      } else {
        print("Reconnection failed. Serial number is still null.");
      }
    } else {
      print("Reconnection skipped. Pinpad is already connected.");
    }
  }

  /// Performs a single action while ensuring connection.
  Future<void> performWithConnection({
    required BuildContext context,
    required Future<void> Function() action,
    required Future<void> Function() onConnectionLost,
  }) async {
    print("Checking pinpad connection...");
    String? serialNumber = await getSerialNumber();

    if (serialNumber == null) {
      if (_isConnected) {
        print("Connection lost! Serial number is null.");
      } else {
        print("Pinpad still disconnected.");
      }

      _isConnected = false;
      await onConnectionLost();
      return;
    }

    if (!_isConnected) {
      print("Pinpad connected successfully. Serial: $serialNumber");
    } else {
      print("Pinpad is already connected. Serial: $serialNumber");
    }

    _isConnected = true;

    try {
      print("Executing action while connected...");
      await action();
      print("Action completed successfully.");
    } catch (e) {
      print("Error during action execution: $e");
    }
  }
}
