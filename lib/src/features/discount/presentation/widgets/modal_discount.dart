// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/features/device/presentation/blocs/device_bloc/device_bloc.dart';
import 'package:pwa_sales2go_flutter/src/features/device/presentation/view/camera_scanner_screen.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

import '../bloc/discount_bloc.dart';

class ModalDiscount extends StatefulWidget {
  const ModalDiscount({
    super.key,
  });

  @override
  State<ModalDiscount> createState() => _ModalDiscountState();
}

class _ModalDiscountState extends State<ModalDiscount> {
  final formKey = GlobalKey<FormState>();
  String? code;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return BarcodeKeyboardListener(
      onBarcodeScanned: (barcode) {
        final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
        if (!isCurrent) return;
        context.read<DeviceBloc>().add(CheckScannerHardwareEvent());
      },
      child: BlocListener<DeviceBloc, DeviceState>(
        listener: (context, state) async {
          if (state is HardwareChecked) {
            if (state.hasScannerHardware) {
              context.read<DeviceBloc>().add(const StartHardwareScanEvent(30));
            } else {
              final result = await Navigator.pushNamed(
                context,
                CameraBarcodeScannerScreen.routeName,
              ) as String?;
              if (result != null) {
                context.read<DiscountBloc>().add(GetDiscountEvent(result));
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
              }
            }
          }
          if (state is HardwareScanState) {
            context
                .read<DiscountBloc>()
                .add(GetDiscountEvent(state.scanResult));
            Navigator.pop(context);
          }
        },
        child: AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Escanea o escribe tu código promocional",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          themeProvider.myTheme.colorScheme.onPrimaryContainer,
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(
                      child: _TextFieldCode(
                        onChanged: (value) {
                          setState(() {
                            code = value;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? false) {
                            return "Código inválido";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<DeviceBloc>().add(
                              CheckScannerHardwareEvent(),
                            );
                      },
                      icon: Icon(
                        Icons.qr_code_scanner,
                        color: themeProvider.myTheme.colorScheme.primary,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  context.read<DiscountBloc>().add(GetDiscountEvent(code!));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                "Aplicar",
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldCode extends StatelessWidget {
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const _TextFieldCode({this.onChanged, this.validator});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return TextFormField(
      style: const TextStyle(fontSize: 14),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      validator: validator,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
        hintText: "Escriba el código",
        hintStyle: TextStyle(
          fontSize: 14,
          color: themeProvider.myTheme.colorScheme.primary,
        ),
        border: _border(),
        focusedBorder: _border(),
        enabledBorder: _border(),
      ),
      onChanged: onChanged,
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: Color(0xFFDFE0FF),
      ),
    );
  }
}
