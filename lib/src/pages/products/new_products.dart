// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/screens/products_list.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewProductsPage extends StatefulWidget {
  const NewProductsPage({
    Key? key,
    this.listOfProducts,
    this.listOfPrices,
    this.userZoneDocument,
    this.showFullList,
    this.pricesName,
  }) : super(key: key);

  final listOfProducts;
  final listOfPrices;
  final userZoneDocument;
  final pricesName;
  final bool? showFullList;

  @override
  State<NewProductsPage> createState() => _NewProductsPageState();
}

class _NewProductsPageState extends State<NewProductsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBarNavigation(
        message: AppLocalizations.of(context)!.products,
        userZoneDocument: widget.userZoneDocument,
      ),
      backgroundColor: themeProvider.myTheme.colorScheme.surface,
      body: MultiProvider(
        providers: [
          StreamProvider<StockModel?>.value(
            value: DatabaseServiceStreams().stockValues,
            initialData: null,
            catchError: (context, error) {
              return;
            },
          ),
        ],
        child: ProductsList(),
      ),
    );
  }
}
