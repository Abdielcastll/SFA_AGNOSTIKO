import 'package:flutter/material.dart';

class PromotionTab extends StatefulWidget {
  const PromotionTab({Key? key}) : super(key: key);

  @override
  State<PromotionTab> createState() => _PromotionTabState();
}

class _PromotionTabState extends State<PromotionTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Promociones'),
    );
  }
}
