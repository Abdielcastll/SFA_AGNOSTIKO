import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/features/product/data/product_list_info.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/product_card.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductListInfo>(
      future: ProductListInfo.instance,
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

        if (!snapshot.hasData || ProductListInfo.products.isEmpty) {
          return const Center(child: Text("Sin productos disponibles"));
        }

        final items = ProductListInfo.products;
        final filteredItems =
            items.where((item) => item.products.isNotEmpty).toList();
        final size = MediaQuery.of(context).size;
        const minItemWidth = 200;
        final itemsByCol = (size.width / minItemWidth).floor();
        int crossAxisCount = min(5, max(itemsByCol, 2)); // Force at least 2 products by row, and at most 5

        return SafeArea(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.59,
            ),
            padding: const EdgeInsets.all(8.0),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return ProductCard(
                baseProduct: filteredItems[index],
                sku: filteredItems[index].products[0].sku,
              );
            },
          ),
        );
      },
    );
  }
}
