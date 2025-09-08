import 'package:flutter/material.dart';

class TokenCheckScreen extends StatelessWidget {
  const TokenCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFF03045E),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/logo_agnostiko_eslogan.png",
              color: Colors.white),
          const SizedBox(
            height: 60,
          ),
          const Visibility(visible: true, child: CircularProgressIndicator())
        ]));
  }
}
