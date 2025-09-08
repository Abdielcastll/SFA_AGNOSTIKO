import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/device_bloc/device_bloc.dart';

class ErrorTokenScreen extends StatelessWidget {
  const ErrorTokenScreen({super.key});
  static const routeName = '/token_error';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF03045E),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo_agnostiko_eslogan.png",
              color: Colors.white),
          const SizedBox(
            height: 10,
          ),
          const Card(
            color: Color(0xFF03045E),
            child: ListTile(
              title: Center(
                child: Text(
                  "Por favor, contacte a su proveedor de servicio.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Future.delayed(const Duration(milliseconds: 250), () {
                context.read<DeviceBloc>().add(GetDeviceEvent());
              });
            },
            child: const Text(
              "Reintentar",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
