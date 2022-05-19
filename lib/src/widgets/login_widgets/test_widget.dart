import 'package:flutter/material.dart';

class TestWidgets extends StatelessWidget {
  const TestWidgets({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shop, size: 20),
            label: const Text('Test productos', style: TextStyle(fontSize: 15)),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('product');
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.person, size: 20),
            label: const Text('Test clientes', style: TextStyle(fontSize: 15)),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('client');
            },
          ),
        ),
      ],
    );
  }
}
