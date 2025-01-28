import 'package:flutter/material.dart';

class ProductsDetailsMiddleSection extends StatelessWidget {
  const ProductsDetailsMiddleSection({
    super.key,
    required this.priceText,
    required this.stockText,
    required this.colorNames,
    required this.onDropdownColorSelected,
    required this.selectedDropdownColor,
    required this.genderOptions,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  final String priceText;
  final String stockText;
  final List<String> colorNames;
  final ValueChanged<String>? onDropdownColorSelected;
  final String? selectedDropdownColor;
  final List<String> genderOptions;
  final String selectedGender;
  final ValueChanged<String>? onGenderSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Detalles de Producto",
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B1B1F),
                ),
              ),
            ),
            if (priceText.isNotEmpty) const SizedBox(height: 8.0),

            // Stock
            if (stockText.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Stock: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',
                      color: Color(0xFF5A5D77),
                    ),
                  ),
                  Text(
                    "$stockText en inventario",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Regular',
                      color: Color(0xFF5A5D77),
                    ),
                  ),
                ],
              ),
            if (stockText.isNotEmpty) const SizedBox(height: 8.0),

            if (genderOptions.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Selecciona género:",
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      color: Color(0xFF5A5D77),
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedGender,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: genderOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        onGenderSelected?.call(newValue);
                      }
                    },
                  ),
                ],
              ),

            if (colorNames.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Selecciona un color:",
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      color: Color(0xFF5A5D77),
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedDropdownColor,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: colorNames.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        onDropdownColorSelected?.call(newValue);
                      }
                    },
                  ),
                ],
              ),
            Center(
                child: Text(
              'Precio : \$ $priceText',
              style: const TextStyle(
                fontSize: 25,
                fontFamily: 'Poppins-Regular',
                color: Color(0xFF5A5D77),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
