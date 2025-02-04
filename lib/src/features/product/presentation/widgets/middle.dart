import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/core/font_size.dart';

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
    this.quality = "",
    this.brand = "",
    this.category = "",
  });

  final String priceText;
  final String stockText;
  final List<String> colorNames;
  final ValueChanged<String>? onDropdownColorSelected;
  final String? selectedDropdownColor;
  final List<String> genderOptions;
  final String selectedGender;
  final ValueChanged<String>? onGenderSelected;
  final String quality;
  final String brand;
  final String category;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: PoppinsText(
                text: "Detalles de Producto",
                fontSize: FontSize.fontXL,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (priceText.isNotEmpty) SizedBox(height: screenHeight * 0.008),

            if (quality.isNotEmpty && quality != "NA")
              TextDetail(
                label: "Calidad: ",
                descriptor: PoppinsText(text: quality),
              ),

            if (category.isNotEmpty && category != "NA")
              TextDetail(
                label: "Categoría: ",
                descriptor: PoppinsText(text: category),
              ),

            if (brand.isNotEmpty && brand != "NA")
              TextDetail(
                label: "Marca: ",
                descriptor: PoppinsText(text: brand),
              ),

            // Stock
            if (stockText.isNotEmpty)
              TextDetail(
                label: "Stock: ",
                descriptor: PoppinsText(text: "$stockText en inventario"),
              ),

            if (stockText.isNotEmpty) SizedBox(height: screenHeight * 0.008),

            if (genderOptions.isNotEmpty)
              TextDetail(
                label: "Selecciona género:",
                descriptor: DropdownButton<String>(
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
              ),

            if (colorNames.isNotEmpty)
              TextDetail(
                label: "Selecciona un color: ",
                descriptor: DropdownButton<String>(
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
              ),

            Center(
              child: PoppinsText(
                text: "Precio: $priceText",
                fontSize: FontSize.fontXL,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextDetail extends StatelessWidget {
  const TextDetail({
    super.key,
    required this.label,
    required this.descriptor,
  });

  final String label;
  final Widget descriptor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.008,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PoppinsText(text: label),
          descriptor,
        ],
      ),
    );
  }
}

class PoppinsText extends StatelessWidget {
  const PoppinsText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
  });

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Poppins-Regular',
        fontSize: fontSize ?? FontSize.fontL,
        fontWeight: fontWeight,
        color: const Color(0xFF5A5D77),
      ),
    );
  }
}
