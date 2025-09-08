import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:agnostiko/agnostiko.dart';
import 'package:rxdart/rxdart.dart';

const serialEventsChannel =
    const EventChannel('agnostiko/SerialPortEvents');
const serialMethodsChannel =
    const MethodChannel('agnostiko/SerialPortMethods');

StreamSubscription<dynamic>? _serialReaderSubscription;
BehaviorSubject<SerialDataEvent>? _streamController;

class SerialDataEvent {
  final Uint8List data;
  const SerialDataEvent(this.data);
}

Stream<SerialDataEvent> openSerial() {
  if (_serialReaderSubscription != null) {
    throw StateError("El puerto ya esta abierto");
  }

  final streamController = BehaviorSubject<SerialDataEvent>();

  _serialReaderSubscription =
      serialEventsChannel.receiveBroadcastStream().listen(
    (data) {
      final resultMap = data as Map;
      final Uint8List receivedData = resultMap["data"] as Uint8List;
      streamController.add(SerialDataEvent(receivedData));
    },
    onError: (dynamic error, StackTrace stackTrace) {
      streamController.addError(error, stackTrace);
      streamController.close();
      _serialReaderSubscription = null;
    },
    onDone: () {
      streamController.close();
      _serialReaderSubscription = null;
    },
    cancelOnError: true,
  );

  _streamController = streamController;
  return streamController.stream;
}

Future<void> writeSerial(Uint8List data) async {
  return await serialMethodsChannel.invokeMethod("writeSerial", data);
}

Future<void> closeSerial() async {
  await _streamController?.close();
  await _serialReaderSubscription?.cancel();
  _serialReaderSubscription = null;
  return await serialMethodsChannel.invokeMethod("closeSerial");
}
