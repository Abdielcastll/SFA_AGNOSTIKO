import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/entitites/product_variant_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/enums/product_size_enum.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/button.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/middle.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/productos_detail_body.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/top.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailUI extends StatefulWidget {
  const ProductDetailUI({
    Key? key,
    required this.productName,
    required this.priceText,
    required this.sizes,
    required this.colorOptions,
    required this.genderOptions,
    required this.products,
  }) : super(key: key);

  final String productName;
  final String priceText;
  final List<ProductSize> sizes;
  final List<String> colorOptions;
  final List<String> genderOptions;
  final List<ProductVariantEntity> products;

  @override
  _ProductDetailUIState createState() => _ProductDetailUIState();
}

class _ProductDetailUIState extends State<ProductDetailUI> {
  ProductSize selectedSize = ProductSize.std;
  String selectedGender = "";
  String selectedDropdownColor = "";
  int selectedProduct = 0;

  @override
  void initState() {
    super.initState();

    selectedSize =
        widget.sizes.isNotEmpty ? widget.sizes.first : ProductSize.std;
    selectedGender =
        widget.genderOptions.isNotEmpty ? widget.genderOptions.first : "";
    selectedDropdownColor =
        widget.colorOptions.isNotEmpty ? widget.colorOptions.first : "";
  }

  @override
  Widget build(BuildContext context) {
    final userZoneDocument = context.watch<CurrentUserInfo>().zoneDocument;

    return Scaffold(
      appBar: AppBarNavigation(
        message: AppLocalizations.of(context)!.products,
        userZoneDocument: userZoneDocument,
      ),
      body: NewProductDetailsBody(
        topSection: ProductsDetailsTopSections(
          sku: widget.products[selectedProduct].sku,
          productName: widget.productName,
          selectedSize: selectedSize,
          descripcion: "Audifonos Cool",
          sizes: widget.sizes,
          onSizeSelected: (value) {
            setState(() {
              selectedSize = value;
            });
          },
        ),
        middleSection: ProductsDetailsMiddleSection(
          priceText: widget.priceText,
          stockText: "50 en inventario",
          colorNames: widget.colorOptions,
          selectedDropdownColor: selectedDropdownColor,
          onDropdownColorSelected: (value) {
            setState(() {
              selectedDropdownColor = value;
            });
          },
          genderOptions: widget.genderOptions,
          selectedGender: selectedGender,
          onGenderSelected: (value) {
            setState(() {
              selectedGender = value;
            });
          },
        ),
        bottomSection: BottonSection(
          onAddToCart: () {
            // Lógica para añadir al carrito
            print("Añadido al carrito con:");
            print("Tamaño: $selectedSize");
            print("Color: $selectedDropdownColor");
            print("Género: $selectedGender");
          },
        ),
      ),
    );
  }
}
