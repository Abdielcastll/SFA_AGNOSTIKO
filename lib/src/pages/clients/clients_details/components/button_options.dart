import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/account_balance.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/account_tabs.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ButtonOptions extends StatelessWidget {
  const ButtonOptions({
    Key? key,
    this.specialContribuyer,
    this.masterDiscount,
    this.fiscalAddress,
    this.email,
    this.listOfPrices,
    this.name,
    this.tlf1,
    this.tlf2,
    this.zone,
    this.nameId,
    this.typeId,
    this.clientDocumentReferenceID,
    this.dispactAddress,
  }) : super(key: key);

  final specialContribuyer;
  final masterDiscount;
  final fiscalAddress;
  final email;
  final listOfPrices;
  final name;
  final tlf1;
  final tlf2;
  final zone;
  final nameId;
  final typeId;
  final clientDocumentReferenceID;
  final dispactAddress;

  @override
  Widget build(BuildContext context) {
    final orderActive = Provider.of<OrderProvider>(context);
    final currentClientForTheOrder =
        Provider.of<OrderProvider>(context).clientForTheOrder;
    // final userRole = Provider.of<CurrentUserInfo>(context).role;

    // print('userRole IN CLIENT DETAILS: $userRole');

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 170,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: myTheme.colorScheme.primary,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AccountTabs(
                        clientDocument: clientDocumentReferenceID.toString(),
                        clientName: name,
                        clientDocumentReferenceID: clientDocumentReferenceID,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  MaterialCommunityIcons.calendar_month_outline,
                  color: myTheme.colorScheme.primary,
                  size: 18,
                ),
                label: Text(
                  AppLocalizations.of(context)!.clientRecord,
                  style: TextStyle(
                    color: myTheme.colorScheme.primary,
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color?>(
                    Colors.white,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    myTheme.colorScheme.primary.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 170,
            height: 35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  final orderActive =
                      Provider.of<OrderProvider>(context, listen: false);
                  final currentClientForTheOrder =
                      Provider.of<OrderProvider>(context, listen: false)
                          .clientForTheOrder;

                  Clients? client = Clients(
                    active: true,
                    specialContributor: specialContribuyer,
                    masterDiscount: masterDiscount,
                    fiscalAdress: fiscalAddress,
                    dispatchAdress: dispactAddress,
                    email: email,
                    prices: listOfPrices,
                    name: name,
                    phone1: tlf1,
                    phone2: tlf2,
                    zone: zone,
                    id: nameId,
                    idType: typeId,
                    clientDocumentId: clientDocumentReferenceID,
                    madeBy: '',
                    modified: DateTime.now(),
                  );
                  orderActive.orderActive == true
                      ? print('')
                      : orderActive.setOrder(true, client);
                  orderActive.orderActive == true
                      ? currentClientForTheOrder?.name == name
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: const RouteSettings(name: "ORDER"),
                                builder: (context) => const OrderPage(),
                              ),
                            )
                          : print('')
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(name: "ORDER"),
                            builder: (context) => const OrderPage(),
                          ),
                        );
                },
                icon: Icon(
                  orderActive.orderActive == false
                      ? MaterialCommunityIcons.cart_plus
                      : Icons.shopping_cart_checkout,
                  color: myTheme.colorScheme.background,
                  size: 22,
                ),
                label: Text(
                  orderActive.orderActive == false
                      ? AppLocalizations.of(context)!.makeOrder
                      : currentClientForTheOrder?.name == name
                          ? 'Cliente actual'
                          : 'Orden en progreso',
                  style: TextStyle(
                    color: myTheme.colorScheme.background,
                    fontFamily: 'Poppins-regular',
                    fontSize: orderActive.orderActive == false ? 14 : 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color?>(
                    orderActive.orderActive == false
                        ? myTheme.colorScheme.primary
                        : currentClientForTheOrder?.name == name
                            ? Colors.green
                            : myTheme.colorScheme.error,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    orderActive.orderActive == false
                        ? myTheme.colorScheme.background
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
