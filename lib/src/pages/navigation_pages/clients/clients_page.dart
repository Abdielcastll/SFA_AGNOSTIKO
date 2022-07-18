// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/clients/widgets/client_card.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('pantalla clientes activa');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SizedBox(height: 5.0),
              _ClientList(),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClientList extends StatelessWidget {
  const _ClientList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _clientsQuery = FirebaseFirestore.instance.collection('clientes');

    return Container(
      padding: EdgeInsets.only(top: 8.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      color: Colors.grey[100],
      child: StreamBuilder<QuerySnapshot>(
        stream: _clientsQuery.orderBy('nombre').limit(10).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return Scrollbar(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final clients = snapshot.data!.docs[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          ClientCard(
                            name: clients['nombre'],
                            phone: clients['telefono'],
                            email: clients['email'],
                            active: clients['activo'],
                            address: clients['direccionFiscal'],
                            specialContributor:
                                clients['contribuyenteEspecial'],
                            clientId: clients['numeroId'],
                            zone: clients['zona'],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              Center(child: Text('No hay clientes disponibles'));
            }
          }
          return Center(
              child: Text('Hubo un problema conectandose a los clientes'));
        },
      ),
    );
  }
}
