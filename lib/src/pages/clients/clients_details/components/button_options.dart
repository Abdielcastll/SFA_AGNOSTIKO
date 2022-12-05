// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
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
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                onPressed: () {},
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
          Container(
            width: 170,
            height: 35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ElevatedButton.icon(
                onPressed: () {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(
                        client: client,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  MaterialCommunityIcons.cart_plus,
                  color: myTheme.colorScheme.background,
                  size: 22,
                ),
                label: Text(
                  AppLocalizations.of(context)!.makeOrder,
                  style: TextStyle(
                    color: myTheme.colorScheme.background,
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color?>(
                    myTheme.colorScheme.primary,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    myTheme.colorScheme.background,
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
