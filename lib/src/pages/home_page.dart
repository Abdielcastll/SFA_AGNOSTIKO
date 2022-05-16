import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar_offline.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: AppBarOffline(),
      ),
      body: Column(
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
      ),
    );
  }
}
