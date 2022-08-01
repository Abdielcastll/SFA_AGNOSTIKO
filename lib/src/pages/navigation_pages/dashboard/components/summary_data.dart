// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class SummaryData extends StatefulWidget {
  const SummaryData({
    Key? key,
  }) : super(key: key);

  @override
  State<SummaryData> createState() => _SummaryDataState();
}

class _SummaryDataState extends State<SummaryData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(height: 5),
          GestureDetector(
            // redireccion a Agenda
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                height: 50,
                width: 340,
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 15),
                    Text(
                      'Agenda',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 150),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration:
                            BoxDecoration(color: myTheme.colorScheme.secondary),
                        child: Center(
                          // Mostrar numero de visitas
                          child: Text(
                            '0',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Icon(AntDesign.caretright,
                          color: myTheme.colorScheme.secondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              // redireccion a Agenda
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                height: 50,
                width: 340,
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 15),
                    Text(
                      'Facturación',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 113),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration:
                            BoxDecoration(color: myTheme.colorScheme.secondary),
                        child: Center(
                          // Mostrar numero de facturas
                          child: Text(
                            '0',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Icon(AntDesign.caretright,
                          color: myTheme.colorScheme.secondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
