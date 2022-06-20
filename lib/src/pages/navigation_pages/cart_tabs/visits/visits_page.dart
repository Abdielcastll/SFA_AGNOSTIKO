// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  @override
  Widget build(BuildContext context) {
    print('pantalla visitas activa');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              _FilterSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSection extends StatefulWidget {
  const _FilterSection({
    Key? key,
  }) : super(key: key);

  @override
  State<_FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<_FilterSection> {
  @override
  Widget build(BuildContext context) {
    String? dropdownValue;
    final List<Map<String, dynamic>> visits = [
      {
        'name': 'Cliente 1',
        'doc': 'J-26314578',
        'date': '12/12/2020',
        'status:': 'Pendiente',
      },
      {
        'name': 'Cliente 2',
        'doc': 'J-26314578',
        'date': '12/12/2020',
        'status:': 'Pendiente',
      },
      {
        'name': 'Cliente 3',
        'doc': 'J-26314578',
        'date': '12/12/2020',
        'status:': 'Completado',
      },
      {
        'name': 'Cliente 4',
        'doc': 'J-26314578',
        'date': '12/12/2020',
        'status:': 'Completado',
      },
      {
        'name': 'Cliente 5',
        'doc': 'J-26314578',
        'date': '12/12/2020',
        'status:': 'Cancelado',
      },
    ];

    return Container(
      height: 50.0,
      width: double.infinity,
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    );
  }
}
