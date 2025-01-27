import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/entitites/base_product_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/repositories/product_list_repository.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/product_card.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const minItemWidth = 150;
    final cabenPorCol = (size.width / minItemWidth).floor();
    int crossAxisCount = min(5, cabenPorCol);

    return FutureBuilder<List<BaseProductEntity>>(
      future: getDataForSubcategoriesList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error loading products: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Sin productos disponibles"));
        }

        final items = snapshot.data!;
        return SafeArea(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.6,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => ProductCard(
              imageUrl: items[index].mainImageUrl,
              productName: items[index].nameProduct,
              productDescription: items[index].description,
              productPrice: items[index].basePrice,
            ),
          ),
        );
      },
    );
  }
}
