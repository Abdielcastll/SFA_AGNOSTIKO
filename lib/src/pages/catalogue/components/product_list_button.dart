import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListOfProductsButton extends StatefulWidget {
  const ListOfProductsButton({Key? key, required this.isOrderActive})
      : super(key: key);

  final bool isOrderActive;

  @override
  State<ListOfProductsButton> createState() => _ListOfProductsButtonState();
}

class _ListOfProductsButtonState extends State<ListOfProductsButton> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Products>?>(context) ?? [];
    final prices = Provider.of<Prices?>(context)?.prices ?? {};

    final productsList = products;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      width: MediaQuery.of(context).size.width,
      height: 45,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(
                listOfProducts: productsList,
                listOfPrices: prices,
                isOrderActive: widget.isOrderActive,
              ),
            ),
          );
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.all<Color>(
              myTheme.colorScheme.primary.withOpacity(0.5)),
        ),
        icon: Container(
          margin: const EdgeInsets.only(bottom: 3),
          child: Icon(
            MaterialCommunityIcons.tag_outline,
            color: myTheme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: Text(
                AppLocalizations.of(context)!.listOfProducts,
                style: TextStyle(
                  color: myTheme.colorScheme.onPrimaryContainer,
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              MaterialIcons.keyboard_arrow_right,
              color: myTheme.colorScheme.onPrimaryContainer,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
