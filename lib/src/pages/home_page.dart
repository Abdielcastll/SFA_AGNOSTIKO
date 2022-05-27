// ignore_for_file: prefer_const_constructors
// + Home Page: Pagina inicial de la aplicación, se mostrara por ahora solo el
// logo de la compañia.

// Paquete principal de Material de Flutter
import 'package:flutter/material.dart';
// Widget de cambio de Appbar en caso de que haya un usuario conectado
import 'package:pwa_sales2go_flutter/src/widgets/appbar_widgets/appbar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBarWidget(),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: _logoCompany(),
        ),
      ),
    );
  }

  Widget _logoCompany() {
    return Column(
      children: [
        const SizedBox(height: 50),
        const Center(
          child: Text(
            'Sales2Go',
            style: TextStyle(
              fontSize: 45,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 200,
          padding: const EdgeInsets.only(top: 10),
          child: Image.asset('/images/apps2go.png'),
        ),
      ],
    );
  }
}
