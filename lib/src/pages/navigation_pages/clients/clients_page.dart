// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _clients.length,
        itemBuilder: (BuildContext context, int i) {
          final cProfile = _clients[i];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                _ClientCard(
                  name: cProfile['name'],
                  phone: cProfile['phone'],
                  email: cProfile['email'],
                  rubro: cProfile['rubro'],
                ),
              ],
            ),
          );
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
    required this.rubro,
  }) : super(key: key);

  final String name;
  final String phone;
  final String email;
  final String rubro;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          print('tappeada tarjeta para acceder al cliente');
        },
        child: Container(
          width: 360.0,
          height: 68.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.0, top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[500]?.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.0),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Text(
                  phone,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[500]?.withOpacity(0.8),
                  ),
                ),
              ),
              SizedBox(width: 30.0),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    rubro,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[500]?.withOpacity(0.8),
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
