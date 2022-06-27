// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/clients/client_details.dart';

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

    final List<Map<String, dynamic>> _clients = [
      {
        'name': 'Cliente 1',
        'phone': '123456789',
        'email': 'example1@gmail.com',
        'rubro': 'rubro 1',
      },
      {
        'name': 'Cliente 2',
        'phone': '123456789',
        'email': 'example2@gamil.com',
        'rubro': 'rubro 2',
      },
      {
        'name': 'Cliente 3',
        'phone': '123456789',
        'email': 'example3@gamil.com',
        'rubro': 'rubro 3',
      },
      {
        'name': 'Cliente 4',
        'phone': '123456789',
        'email': 'example24@gamil.com',
        'rubro': 'rubro 4',
      },
      {
        'name': 'Cliente 5',
        'phone': '123456789',
        'email': 'example5@gamil.com',
        'rubro': 'rubro 5',
      },
      {
        'name': 'Cliente 6',
        'phone': '123456789',
        'email': 'example6@gamil.com',
        'rubro': 'rubro 6',
      },
      {
        'name': 'Cliente 7',
        'phone': '123456789',
        'email': 'example7@gamil.com',
        'rubro': 'rubro 7',
      },
    ];

    return Container(
      padding: EdgeInsets.only(top: 8.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      color: Colors.grey[100],
      child: StreamBuilder<QuerySnapshot>(
        stream: _clientsQuery.orderBy('nombre').snapshots(),
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
                          _ClientCard(
                            name: clients['nombre'],
                            phone: clients['telefono'],
                            email: clients['email'],
                            active: clients['activo'],
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

class _ClientCard extends StatelessWidget {
  const _ClientCard({
    Key? key,
    required this.name,
    required this.phone,
    required this.email,
    required this.active,
  }) : super(key: key);

  final String name;
  final String phone;
  final String email;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          print('tappeada tarjeta para acceder al cliente');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClientDetails(),
            ),
          );
        },
        child: Container(
          width: 360.0,
          height: 68.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.0, top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    SizedBox(
                      width: 150,
                      child: Text(
                        email,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[500]?.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.0),
              Padding(
                padding: EdgeInsets.only(top: 27),
                child: SizedBox(
                  width: 120,
                  height: 50,
                  child: Text(
                    phone,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[500]?.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    margin: EdgeInsets.only(
                      right: 10,
                    ),
                    child: Text(
                      active ? 'Activo' : 'Inactivo',
                      style: active
                          ? TextStyle(
                              fontSize: 12.0,
                              color: Colors.green[500]?.withOpacity(0.8))
                          : TextStyle(
                              fontSize: 12.0,
                              color: Colors.red[500]?.withOpacity(0.8),
                            ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
