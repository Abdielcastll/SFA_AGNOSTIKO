import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class CameraBarcodeScannerScreen extends StatefulWidget {
  const CameraBarcodeScannerScreen({
    super.key,
  });
  static const routeName = '/cart/barcode_scan_camera';

  @override
  State<CameraBarcodeScannerScreen> createState() =>
      _CameraBarcodeScannerScreenState();
}

class _CameraBarcodeScannerScreenState
    extends State<CameraBarcodeScannerScreen> {
  bool captured = false;

  MobileScannerController cameraController =
      MobileScannerController(facing: CameraFacing.front);

  @override
  void initState() {
    super.initState();
    captured = false;
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    String? scanResult;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.myTheme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text("Escaner de barras"),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(
                      Icons.flash_off,
                      color: Colors.grey,
                    );
                  case TorchState.on:
                    return const Icon(
                      Icons.flash_on,
                      color: Colors.yellow,
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          if (captured) return;
          Future.delayed(const Duration(seconds: 0), () async {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              scanResult = barcode.rawValue.toString();
            }
            setState(() {
              captured = true;
            });
            Navigator.pop(context, scanResult);
          });
        },
      ),
    );
  }
}
