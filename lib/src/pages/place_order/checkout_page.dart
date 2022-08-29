// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/completed_order.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/products.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_checkout.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage(
      {Key? key,
      required this.client,
      required this.cart,
      required this.subTotalPrice})
      : super(key: key);

  final CLientsExample client;
  final List<Product> cart;
  final double subTotalPrice;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCheckout(),
      bottomNavigationBar: const BottomDecoration(),
      backgroundColor: Colors.grey.shade100,
      body: CheckoutBody(
        client: widget.client,
        subTotalPrice: widget.subTotalPrice,
      ),
    );
  }
}

class CheckoutBody extends StatefulWidget {
  const CheckoutBody({
    Key? key,
    required this.client,
    required this.subTotalPrice,
  }) : super(key: key);

  final CLientsExample client;
  final double subTotalPrice;

  @override
  State<CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  List<Product> products = allProductInShoppingCart;
  String? selectedValue;
  String? selectedValue2;
  bool isFiscalSelected = true;
  String commentary = '';
  String moneySymbol = '\$';

  final List<String> items = [
    'Fiscal',
    'Despacho',
  ];

  final List<String> items2 = [
    'Transferencia',
    'Efectivo',
    'Pago Movil',
    'Credito'
  ];

  double priceWithIVA() {
    var total = (widget.subTotalPrice * 16) / 100;
    return total;
  }

  double priceWithMasterDiscount() {
    var total = (widget.subTotalPrice * widget.client.masterDiscount) / 100;
    return total;
  }

  double totalPriceOfTheOrder() {
    var total =
        (widget.subTotalPrice + priceWithIVA() + priceWithMasterDiscount());
    return total;
  }

  @override
  Widget build(BuildContext context) {
    String? fiscalAddress = widget.client.fiscalAddress;
    String? dispatchAddress = 'No Hay direccion disponible';
    DateTime today = DateTime.now();
    var dateFormatter = DateFormat('dd-MM-yyyy');
    String formattedDate = dateFormatter.format(today);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SelectedClient(
            client: widget.client,
            isEditable: false,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Subtotal',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$moneySymbol ${widget.subTotalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Descuento Maestro',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '% ${widget.client.masterDiscount}',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'IVA (16%)',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$moneySymbol ${priceWithIVA().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Total del pedido',
                        style: TextStyle(
                          color: myTheme.colorScheme.secondary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$moneySymbol ${totalPriceOfTheOrder().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.secondary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    'Dirección de entrega',
                    style: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      // ignore: prefer_const_literals_to_create_immutables
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Fiscal',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.7),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: myTheme.colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(
                          () {
                            selectedValue = value as String;
                            if (value == 'Fiscal') {
                              isFiscalSelected = true;
                            } else if (value == 'Despacho') {
                              isFiscalSelected = false;
                            }
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 11,
                      iconEnabledColor:
                          myTheme.colorScheme.primary.withOpacity(0.5),
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 50,
                      buttonWidth: 150,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.3),
                        ),
                        color: Colors.white,
                      ),
                      buttonElevation: 0,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(10),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(-20, 0),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: myTheme.colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    isFiscalSelected ? fiscalAddress : dispatchAddress,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Orden de la compra',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Fecha de Entrega',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            '1000586',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  myTheme.colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                          Icon(Icons.numbers_sharp,
                              color: myTheme.colorScheme.primary, size: 20),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  myTheme.colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                          Icon(Icons.calendar_month,
                              color: myTheme.colorScheme.primary, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    'Tipo de negociacion',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: myTheme.colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      // ignore: prefer_const_literals_to_create_immutables
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Factura',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: myTheme.colorScheme.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: items2
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: myTheme.colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue2,
                      onChanged: (value) {
                        setState(
                          () {
                            selectedValue2 = value as String;
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 11,
                      iconEnabledColor:
                          myTheme.colorScheme.primary.withOpacity(0.5),
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 50,
                      buttonWidth: 150,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.3),
                        ),
                        color: Colors.white,
                      ),
                      buttonElevation: 0,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(10),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(-20, 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Text(
                    'Comentario',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: myTheme.colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 14,
                      color: myTheme.colorScheme.primary,
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 200,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                      hintText: 'Comentario sobre la entrega',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: myTheme.colorScheme.primary.withOpacity(0.4),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: myTheme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        commentary = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Hacer Showdialog de confirmacion
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompletedOrderPage(
                        client: widget.client.name,
                        date: formattedDate,
                        method: selectedValue2,
                        total: totalPriceOfTheOrder(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: myTheme.colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CONTINUAR',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Icon(
                        SimpleLineIcons.arrow_right,
                        size: 14,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
