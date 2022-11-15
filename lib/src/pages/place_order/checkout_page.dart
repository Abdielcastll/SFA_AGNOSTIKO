// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/completed_order.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_checkout.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    Key? key,
    required this.client,
    required this.cart,
    required this.subTotal,
    this.coinsExchangeRates,
  }) : super(key: key);

  final Clients? client;
  final List<ShoppingCartProduct> cart;
  final double subTotal;
  final coinsExchangeRates;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCheckout(),
      backgroundColor: Colors.grey.shade100,
      body: CheckoutBody(
        client: widget.client,
        subTotal: widget.subTotal,
        cart: widget.cart,
        coinsExchangeRates: widget.coinsExchangeRates,
      ),
    );
  }
}

class CheckoutBody extends StatefulWidget {
  const CheckoutBody({
    Key? key,
    required this.client,
    required this.subTotal,
    required this.cart,
    this.coinsExchangeRates,
  }) : super(key: key);

  final Clients? client;
  final double subTotal;
  final List<ShoppingCartProduct> cart;
  final coinsExchangeRates;

  @override
  State<CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  String? selectedValue = 'Fiscal';
  String? selectedValue2;
  String commentary = '';
  String moneySymbol = '\$';
  bool isFiscalSelected = true;
  var numberOrder;
  DateTime today = DateTime.now();
  DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
  final currentCoin = sharedPreferences!.getString('currentCoin');

  final List<String> items = ['Fiscal', 'Despacho'];

  final List<String> items2 = ['Consignacion', 'Factura', 'Nota de entrega'];

  late List<double> coinsExchangeRates = widget.coinsExchangeRates;

  identifyPrice(price) {
    if (currentCoin == 'USD' || currentCoin == null) {
      return price.toStringAsFixed(2);
    } else if (currentCoin == 'VED') {
      return (price * coinsExchangeRates[2]).toStringAsFixed(2);
    } else if (currentCoin == 'EUR') {
      return (price * coinsExchangeRates[1]).toStringAsFixed(2);
    } else if (currentCoin == 'BTC') {
      return (price * coinsExchangeRates[0]).toStringAsFixed(8);
    }
  }

  double priceWithIVA() {
    var total = (widget.subTotal * 16) / 100;
    return total;
  }

  double priceWithMasterDiscount() {
    var total = (widget.subTotal / 100) * widget.client?.masterDiscount;
    return total;
  }

  double totalPriceOfTheOrder() {
    var total = (widget.subTotal + priceWithIVA()) - priceWithMasterDiscount();
    return total;
  }

  completeOrder() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CompletedOrderPage(
          client: widget.client?.name,
          address: selectedValue == 'Fiscal'
              ? widget.client!.fiscalAdress
              : widget.client!.dispatchAdress,
          orderNumber: numberOrder ?? 0000,
          date: dateFormatter.format(today),
          method: selectedValue2,
          total: totalPriceOfTheOrder(),
          coinsExchangeRates: widget.coinsExchangeRates,
        ),
      ),
    );
  }

  identifyCurrency() {
    if (currentCoin == 'USD' || currentCoin == null) {
      return '\$';
    } else if (currentCoin == 'VED') {
      return 'BS';
    } else if (currentCoin == 'EUR') {
      return '€';
    } else if (currentCoin == 'BTC') {
      return '฿';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userUid = Provider.of<UserModel>(context).uid;
    int? clientMasterDiscount = widget.client?.masterDiscount;
    double? masterDiscountTotal = priceWithMasterDiscount();
    double? taxTotal = priceWithIVA();
    double? totalOfTheOrder = totalPriceOfTheOrder();
    String? fiscalAddress = widget.client?.fiscalAdress;
    String? dispatchAddress =
        widget.client?.dispatchAdress ?? 'No Hay direccion disponible';
    String moneySymbol = identifyCurrency();
    String formattedDate = dateFormatter.format(today);

    // print(today);
    // print(userUid);
    // print(coinsExchangeRates);

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SelectedClient(
            client: widget.client,
            isEditable: false,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                        '$moneySymbol ${identifyPrice(widget.subTotal)}',
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
                        'Descuento Maestro ($clientMasterDiscount%)',
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
                        '$moneySymbol ${identifyPrice(masterDiscountTotal)}',
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
                        '$moneySymbol ${identifyPrice(taxTotal)}',
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
                        '$moneySymbol ${identifyPrice(totalOfTheOrder)}',
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
                              '$selectedValue',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: myTheme.colorScheme.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: items
                          .map(
                            (item) => DropdownMenuItem<String>(
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
                            ),
                          )
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
                            // print(selectedValue);
                            // print(selectedValue == 'Fiscal'
                            //     ? widget.client?.fiscalAdress
                            //     : widget.client?.dispatchAdress);
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
                    isFiscalSelected
                        ? widget.client?.fiscalAdress
                        : widget.client?.dispatchAdress,
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
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                      // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      // height: 100,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 14,
                            color: myTheme.colorScheme.primary,
                          ),
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          maxLength: 10,
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                            hintText: '0000',
                            counterText: "",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color:
                                  myTheme.colorScheme.primary.withOpacity(0.4),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.3),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              numberOrder = value;
                            });
                            // print(numberOrder);
                          },
                        ),
                      ),
                    ),
                    Icon(
                      Icons.numbers_rounded,
                      color: myTheme.colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 50),
                    Container(
                      height: 47,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.7),
                              ),
                            ),
                          ),
                          Container(
                            width: 30,
                            child: IconButton(
                              onPressed: () async {
                                // Seleccionar fecha
                                DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: today,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2023),
                                );
                                if (newDate == null) return;
                                setState(() {
                                  today = newDate;
                                  (today);
                                });
                              },
                              splashRadius: 5,
                              icon: Icon(
                                Icons.calendar_month,
                                color: myTheme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ),
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
                  width: 300,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      // ignore: prefer_const_literals_to_create_immutables
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Seleccione una opcion',
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
                        setState(() {
                          selectedValue2 = value as String;
                          (selectedValue2);
                        });
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
                        // print(commentary);
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
                onPressed: () async {
                  // Procesar pedido a la DB
                  if (selectedValue2 != null) {
                    var result = await createOrder(
                      widget.client,
                      userUid,
                      commentary,
                      masterDiscountTotal,
                      widget.cart,
                      selectedValue2,
                      selectedValue,
                      today,
                      taxTotal,
                      numberOrder,
                      widget.subTotal,
                      totalOfTheOrder,
                    );

                    completeOrder();
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Seleccione un tipo de Negociacion por favor');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myTheme.colorScheme.primary,
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
