import 'package:flutter/material.dart';

class CatalogueTab extends StatefulWidget {
  const CatalogueTab({Key? key}) : super(key: key);

  @override
  State<CatalogueTab> createState() => _CatalogueTabState();
}

class _CatalogueTabState extends State<CatalogueTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Catalogo'),
    );
  }
}
