import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
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

class ClientDetails extends StatefulWidget {
  const ClientDetails({
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
    required this.dispatchAddress,
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
  final dispatchAddress;

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  @override
  Widget build(BuildContext context) {
    // print('userRole IN CLIENT DETAILS: $userRole');

    return Scaffold(
      backgroundColor: myTheme.colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        backgroundColor: myTheme.colorScheme.primary,
      ),
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
        clientDocumentReferenceID: widget.clientDocumentReferenceID,
        dispatchAddress: widget.dispatchAddress,
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
    required this.clientDocumentReferenceID,
    required this.dispatchAddress,
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
  final dispatchAddress;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClientPicture(
              name: name, documentReferenceId: clientDocumentReferenceID),
          SizedBox(height: 16),
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontFamily: 'Poppins-regular',
              ),
            ),
          ),
          ButtonOptions(
            specialContribuyer: specialContribuyer,
            masterDiscount: masterDiscount,
            fiscalAddress: fiscalAddress,
            email: email,
            listOfPrices: listOfPrices,
            name: name,
            tlf1: tlf1,
            tlf2: tlf2,
            zone: zone,
            nameId: nameId,
            typeId: typeId,
            clientDocumentReferenceID: clientDocumentReferenceID,
            dispactAddress: dispatchAddress,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
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
