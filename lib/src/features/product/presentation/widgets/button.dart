import 'package:flutter/material.dart';

class BottonSection extends StatelessWidget {
  const BottonSection({
    super.key,
    required this.onAddToCart,
  });

  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Center(
        child: ElevatedButton.icon(
            icon: const Icon(Icons.add_shopping_cart_rounded,
            color: Color.fromARGB(255, 0, 24, 143),),
          onPressed: onAddToCart,
          style: ButtonStyle(
            shadowColor:MaterialStateProperty.all<Color>( Colors.transparent),
            backgroundColor:MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(67, 83, 194, 1).withOpacity(0.3)),
            ),
          label: const Text('Añadir al carrito'),
        ),
      ),
    );
  }
}