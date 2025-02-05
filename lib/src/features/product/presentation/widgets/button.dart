import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/core/font_size.dart';

class BottonSection extends StatelessWidget {
  const BottonSection({
    super.key,
    required this.onAddToCart,
  });

  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: onAddToCart,
          icon: Icon(
            Icons.add_shopping_cart_rounded,
            color: Colors.white,
            size: FontSize.fontXL,
          ),
          label: Text(
            "Añadir al carrito",
            style: TextStyle(color: Colors.white, fontSize: FontSize.fontXL),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.primary),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }
}
