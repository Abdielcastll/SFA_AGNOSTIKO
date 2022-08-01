// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ClientInfo extends StatelessWidget {
  const ClientInfo({
    Key? key,
    required this.name,
    required this.address,
    required this.specialContributor,
    required this.phone,
    required this.email,
    required this.clientId,
    this.zone,
  }) : super(key: key);

  final String name;
  final String address;
  final bool specialContributor;
  final String phone;
  final String email;
  final dynamic clientId;
  final dynamic zone;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.7,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Container(
              color: Colors.transparent,
              height: 60,
              width: double.infinity,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          _DirectionCard(
            zone: zone,
            specialContributor: specialContributor,
          ),
          SizedBox(height: 16),
          _InfoCard(
            phone: phone,
            email: email,
          ),
          SizedBox(height: 16),
          _DetailsCard(
            address: address,
            clientId: clientId,
          ),
        ],
      ),
    );
  }
}

class _DirectionCard extends StatelessWidget {
  const _DirectionCard({
    Key? key,
    required this.zone,
    required this.specialContributor,
  }) : super(key: key);

  final dynamic zone;
  final bool specialContributor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 16),
                    child: Text(
                      'Zona',
                      style: TextStyle(
                        // fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 105),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 16),
                    child: Text(
                      'Contribuyente Especial:',
                      style: TextStyle(
                        // fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 16),
                    child: Container(
                      color: Colors.transparent,
                      height: 60,
                      width: 200,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Text(
                          zone.toString(),
                          // 'Calle Leonardo da Vinci, 7, 41092. Address: Calle Leonardo da Vinci, 7, 41092',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, left: 10),
                    child: Container(
                      height: 60,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: myTheme.colorScheme.secondary),
                      ),
                      child: Center(
                        child: specialContributor
                            ? Text('No es contribuyente especial',
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.center)
                            : Text(
                                'Si es contribuyente especial',
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                      ),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    Key? key,
    required this.phone,
    required this.email,
  }) : super(key: key);

  final String phone;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 16),
                    child: Text(
                      'Contacto',
                      style: TextStyle(
                        // fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 16),
                child: Container(
                  color: Colors.transparent,
                  height: 60,
                  width: 300,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            phone,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          email,
                        ),
                      ],
                    ),
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

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    Key? key,
    required this.clientId,
    required this.address,
  }) : super(key: key);

  final dynamic clientId;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 16),
                    child: Text(
                      'Detalles',
                      style: TextStyle(
                        // fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 16),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                '- ID:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(clientId.toString()),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                '- Dirección: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                color: Colors.transparent,
                                height: 90,
                                width: 200,
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Text(
                                      address,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
