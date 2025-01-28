import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/screens/products_list.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/new_products_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListOfProductsButton extends StatefulWidget {
  const ListOfProductsButton({Key? key}) : super(key: key);

  @override
  State<ListOfProductsButton> createState() => _ListOfProductsButtonState();
}

class _ListOfProductsButtonState extends State<ListOfProductsButton> {
  @override
  Widget build(BuildContext context) {
    final prices = Provider.of<Prices?>(context)?.prices ?? {};
    final pricesName = Provider.of<Prices?>(context)?.name ?? {};
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;
    final products = Provider.of<List<Products>?>(context) ?? [];
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // print('products from button: ${products.length}');
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        width: 380,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            final counterLimitProvider =
                Provider.of<CounterLimitFirestore>(context, listen: false);
            if (products.length > 100) {
              counterLimitProvider.setProductsLimit(10, 10);
            } else {
              counterLimitProvider.setProductsLimit(
                  counterLimitProvider.getProductsLimit,
                  counterLimitProvider.getScrollProductLimit);
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => NewProductsPage(
                  listOfPrices: prices,
                  userZoneDocument: userZoneDocument,
                  listOfProducts: const [],
                  showFullList: true,
                  pricesName: pricesName,
                ),
              ),
            );
          },
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.all<Color>(
              themeProvider.myTheme.colorScheme.primary.withOpacity(0.5),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          icon: Container(
            margin: const EdgeInsets.only(bottom: 3, left: 8),
            child: Icon(
              MaterialCommunityIcons.tag_outline,
              color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
              size: 20,
            ),
          ),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 18),
                child: Text(
                  AppLocalizations.of(context)!.listOfProducts,
                  style: TextStyle(
                    color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
                    fontFamily: 'Poppins-medium',
                  ),
                ),
              ),
              Icon(
                MaterialIcons.keyboard_arrow_right,
                color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
