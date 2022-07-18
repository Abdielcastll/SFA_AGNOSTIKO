import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomDecoration(),
      backgroundColor: Colors.white,
      body: cartBody(),
    );
  }

  Widget cartBody() {
    return SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }
}
