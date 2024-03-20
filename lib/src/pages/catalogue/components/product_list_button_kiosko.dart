import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListOfProductsButtonKiosko extends StatefulWidget {
  const ListOfProductsButtonKiosko({Key? key}) : super(key: key);

  @override
  State<ListOfProductsButtonKiosko> createState() =>
      _ListOfProductsButtonKioskoState();
}

class _ListOfProductsButtonKioskoState
    extends State<ListOfProductsButtonKiosko> {
  @override
  Widget build(BuildContext context) {
    final prices = Provider.of<Prices?>(context)?.prices ?? {};
    final pricesName = Provider.of<Prices?>(context)?.name ?? {};
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;
    final products = Provider.of<List<Products>?>(context) ?? [];

    // print('products from button: ${products.length}');
    return Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: const BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            width: MediaQuery.of(context).size.width - 30,
            height: 56,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    myTheme.colorScheme.primary,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  final counterLimitProvider =
                      Provider.of<CounterLimitFirestore>(context,
                          listen: false);
                  if (products.length > 100) {
                    counterLimitProvider.setProductsLimit(10, 10);
                  } else {
                    counterLimitProvider.setProductsLimit(
                        counterLimitProvider.getProductsLimit,
                        counterLimitProvider.getScrollProductLimit);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProductsPage(
                        listOfPrices: prices,
                        userZoneDocument: userZoneDocument,
                        listOfProducts: const [],
                        showFullList: true,
                        pricesName: pricesName,
                      ),
                    ),
                  );
                },
                label: Text(
                  AppLocalizations.of(context)!.addProducts,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins-medium',
                    fontSize: 14,
                  ),
                ),
                icon: const Icon(
                  MaterialCommunityIcons.tag_plus,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
