import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/core/font_size.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/enums/product_size_enum.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/image_network.dart';

class ProductsDetailsTopSections extends StatelessWidget {
  const ProductsDetailsTopSections({
    super.key,
    required this.sku,
    required this.productName,
    required this.selectedSize,
    required this.sizes,
    this.onSizeSelected,
    this.descripcion,
  });

  final String sku;
  final String productName;
  final String? descripcion;
  final ProductSize selectedSize;
  final List<ProductSize> sizes;
  final ValueChanged<ProductSize>? onSizeSelected;

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: ImageFromInternet(
              sku: sku,
              height: ancho * 0.6,
              width: ancho * 0.5,
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: FontSize.font2XL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "SKU: $sku",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: FontSize.fontS,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                // SizedBox(height: alto * 0.004),
                if (descripcion != null)
                  Text(
                    descripcion!,
                    style: TextStyle(
                      fontSize: FontSize.fontL,
                      fontFamily: 'Poppins-Regular',
                      color: const Color(0xFF5A5D77),
                    ),
                  ),
                if (sizes.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        "Talla :",
                        style: TextStyle(
                          fontSize: FontSize.fontL,
                          fontFamily: 'Poppins-Regular',
                          color: const Color(0xFF5A5D77),
                        ),
                      ),
                      SizedBox(
                        width: ancho * 0.008,
                      ),
                      DropdownButton<String>(
                        value: selectedSize
                            .size, // assuming selectedSize is of type ProductSize
                        icon: const Icon(Icons.arrow_drop_down),
                        items: sizes.map((ProductSize size) {
                          return DropdownMenuItem<String>(
                            value: size.size, // use the string value of the enum
                            child: Text(
                              size.size,
                              style: TextStyle(fontSize: FontSize.fontM),
                            ), // display the string value of the enum
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            // Convert string back to enum
                            onSizeSelected
                                ?.call(ProductSizeExtension.fromString(newValue));
                          }
                        },
                      )
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
