// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/drawer/drawer_widget.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> clientsStream =
        FirebaseFirestore.instance.collection('clientes').snapshots();
    // sacar de adentro de "clientes" las colecciones [facturas, notas_credito, pedidos]

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBarHome(
        title: 'Productos',
        backgroundColor: Color(0xFF4f42ed),
      ),
      body: productsBody(clientsStream),
    );
  }

  Widget productsBody(clientsStream) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: SingleChildScrollView(
                  child: StreamBuilder(
                    stream: clientsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Column(
                          children: [
                            Text('Error: ${snapshot.error}'),
                            SizedBox(height: 10),
                            Text('Revisar reglas de Firebase'),
                          ],
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          padding: const EdgeInsets.only(top: 60),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF4f42ed)),
                          ),
                        );
                      }
                      return Container(
                          child: Text('Revisar reglas para permisos'));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
