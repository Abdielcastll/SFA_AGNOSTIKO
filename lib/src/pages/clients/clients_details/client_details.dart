// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/account_balance.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/components/address_info.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/components/button_options.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/components/client_picture.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/components/contact_info.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/components/delivery_address.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/components/invoice_info.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/components/prices_dropdown_menu.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/components/zones_dropdown_menu.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class ClientDetails extends StatefulWidget {
  const ClientDetails({
    Key? key,
    required this.specialContribuyer,
    required this.masterDiscount,
    required this.fiscalAddress,
    required this.email,
    required this.listOfPrices,
    required this.name,
    required this.tlf1,
    required this.tlf2,
    required this.zone,
    required this.nameId,
    required this.typeId,
  }) : super(key: key);

  final bool specialContribuyer;
  final int masterDiscount;
  final String fiscalAddress;
  final String email;
  final String listOfPrices;
  final String name;
  final String tlf1;
  final String tlf2;
  final String zone;
  final int nameId;
  final String typeId;

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: myTheme.colorScheme.primary,
              onPressed: () {
                // Redireccionar a estado de cuenta
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AccountBalancePage(),
                  ),
                );
              },
              child: Icon(
                Icons.account_balance,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        backgroundColor: myTheme.colorScheme.primary,
      ),
      bottomNavigationBar: BottomDecoration(),
      body: ClientDetailsBody(
        specialContribuyer: widget.specialContribuyer,
        masterDiscount: widget.masterDiscount,
        fiscalAddress: widget.fiscalAddress,
        email: widget.email,
        listOfPrices: widget.listOfPrices,
        name: widget.name,
        tlf1: widget.tlf1,
        tlf2: widget.tlf2,
        typeId: widget.typeId,
        nameId: widget.nameId,
        zone: widget.zone,
      ),
    );
  }
}

class ClientDetailsBody extends StatelessWidget {
  const ClientDetailsBody({
    Key? key,
    required this.specialContribuyer,
    required this.masterDiscount,
    required this.fiscalAddress,
    required this.email,
    required this.listOfPrices,
    required this.name,
    required this.tlf1,
    required this.tlf2,
    required this.zone,
    required this.nameId,
    required this.typeId,
  }) : super(key: key);
  final bool specialContribuyer;
  final int masterDiscount;
  final String fiscalAddress;
  final String email;
  final String listOfPrices;
  final String name;
  final String tlf1;
  final String tlf2;
  final String zone;
  final int nameId;
  final String typeId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ClientPicture(name: name),
          ButtonOptions(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Column(
              children: [
                AddressInfo(fiscalAddress: fiscalAddress),
                ContactInfo(tlf1: tlf1, email: email),
                InvoiceInfo(tlf2: tlf2, typeId: typeId, nameId: nameId),
                DeliveryAddress(fiscalAddress: fiscalAddress),
                ZonesDropDownMenu(zone: zone),
                PricesDropDownMenu(
                    listOfPrices: listOfPrices, masterDiscount: masterDiscount),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
