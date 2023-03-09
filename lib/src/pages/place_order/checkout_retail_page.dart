// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/objectbox.g.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/discount.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/completed_order.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_checkout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutRetailPage extends StatefulWidget {
  const CheckoutRetailPage({
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
  State<CheckoutRetailPage> createState() => _CheckoutRetailPageState();
}

class _CheckoutRetailPageState extends State<CheckoutRetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCheckout(),
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
  String? selectedValue2 = 'Factura';
  String? selectedDiscount = '0';
  // double amountPayed = 0;
  String commentary = '';
  bool isFiscalSelected = true;
  var numberOrder;
  int discountByInput = 0;
  DateTime today = DateTime.now();
  DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

  final List<String> items = ['Fiscal', 'Despacho'];

  final List<String> items2 = ['Factura', 'Consignacion', 'Nota de entrega'];

  late List<double> coinsExchangeRates = widget.coinsExchangeRates;

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

  double totalDiscountApplied() {
    var total =
        (totalPriceOfTheOrder() * (discountByInput / 100)).toStringAsFixed(2);
    double doubleTotal = double.parse(total);
    return doubleTotal;
  }

  double totalWithDiscount() {
    var total =
        (totalPriceOfTheOrder() - totalDiscountApplied()).toStringAsFixed(2);
    double doubleTotal = double.parse(total);
    return doubleTotal;
  }

  // double totalDiscountApplied() {
  //   var total = (widget.subTotal - (discountByInput / 100)).toStringAsFixed(2);
  //   double doubleTotal = double.parse(total);
  //   return doubleTotal;
  // }

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
          total: totalWithDiscount(),
          coinsExchangeRates: widget.coinsExchangeRates,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // updatePayed(double amount) {
  //   print('payed $amount');
  //   if (amount != null && amount != 0) {
  //     setState(() {
  //       amountPayed += amount;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final userUid = Provider.of<UserModel>(context).uid;
    int? clientMasterDiscount = widget.client?.masterDiscount;
    double? masterDiscountTotal = priceWithMasterDiscount();
    double? taxTotal = priceWithIVA();
    double? totalOfTheOrder = totalWithDiscount();
    String? fiscalAddress = widget.client?.fiscalAdress;
    String? dispatchAddress =
        widget.client?.dispatchAdress ?? 'No Hay direccion disponible';
    String formattedDate = dateFormatter.format(today);
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;

    priceFormat(productPrice) {
      double correctAmount = double.parse(productPrice.toStringAsFixed(2));
      if (currentCoin!.contains('USD')) {
        return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
            .format(productPrice)
            .toString();
      } else if (currentCoin.contains('VED')) {
        return '\$$correctAmount = ${NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "Bs.",
        ).format(correctAmount * 4.58).toString()}';
      } else if (currentCoin.contains('EUR')) {
        return '\$$correctAmount = ${NumberFormat.currency(
          locale: 'es_ES',
          decimalDigits: 2,
          symbol: '€',
        ).format(correctAmount * 0.89).toString()}';
      } else if (currentCoin.contains('MXN')) {
        return '\$$correctAmount = ${NumberFormat.currency(
          locale: 'es_MX',
          decimalDigits: 2,
          symbol: '\$',
        ).format(correctAmount * 19.43)}';
      } else if (currentCoin.contains('BTC')) {
        return '฿ ${(correctAmount * 0.00011).toString()}';
      } else {
        return '\$$correctAmount = ${NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "PPR.",
        ).format(correctAmount * 4.58).toString()}';
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SelectedClient(
            client: widget.client,
            isEditable: false,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.subtotal,
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${priceFormat(widget.subTotal)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 12,
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
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${AppLocalizations.of(context)!.masterDiscount} ($clientMasterDiscount%)',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${priceFormat(masterDiscountTotal)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 12,
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
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${AppLocalizations.of(context)!.tax} (16%)',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${priceFormat(taxTotal)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 12,
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
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            'Descuento aplicado ($discountByInput%)',
                            style: TextStyle(
                              color: myTheme.colorScheme.primary,
                              fontFamily: 'Poppins-regular',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            child: IconButton(
                              onPressed: () async {
                                print('Menu de aplicar descuentos');
                                List<String> discountsStrings = ['0'];
                                List discounts = defaultDiscounts;
                                for (var discount in discounts) {
                                  String discountString =
                                      (discount.discount * 100)
                                          .round()
                                          .toString();
                                  discountsStrings.add(discountString);
                                }
                                print('Descuentos: $discountsStrings');
                                // List<String> items3 = ['0', '5', '10', '15'];
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      StatefulBuilder(
                                    builder: (context, StateSetter setState) =>
                                        AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Center(
                                        child: Text(
                                          'Aplicar descuento',
                                          style: TextStyle(
                                            color: myTheme.colorScheme.primary,
                                            fontFamily: 'Poppins-regular',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      content: Container(
                                        child: SingleChildScrollView(
                                          child: Column(children: [
                                            Center(
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  isExpanded: true,
                                                  hint: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.list,
                                                        size: 16,
                                                        color: myTheme
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Seleccionar descuento',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: myTheme
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  items: discountsStrings
                                                      .map(
                                                          (item) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value: item,
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        item,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: myTheme
                                                                              .colorScheme
                                                                              .primary,
                                                                          fontFamily:
                                                                              'Poppins-regular',
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      Icon(
                                                                        MaterialCommunityIcons
                                                                            .percent,
                                                                        size:
                                                                            14,
                                                                        color: myTheme
                                                                            .colorScheme
                                                                            .primary,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ))
                                                      .toList(),
                                                  value: selectedDiscount,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedDiscount =
                                                          value as String;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    size: 16,
                                                    color: myTheme
                                                        .colorScheme.primary,
                                                  ),
                                                  iconSize: 14,
                                                  iconEnabledColor: myTheme
                                                      .colorScheme.primary,
                                                  iconDisabledColor:
                                                      Colors.grey,
                                                  buttonHeight: 50,
                                                  buttonWidth: 160,
                                                  buttonPadding:
                                                      const EdgeInsets.only(
                                                          left: 14, right: 14),
                                                  buttonDecoration:
                                                      BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    border: Border.all(
                                                      color: myTheme
                                                          .colorScheme.primary,
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  buttonElevation: 0,
                                                  itemHeight: 40,
                                                  itemPadding:
                                                      const EdgeInsets.only(
                                                          left: 14, right: 14),
                                                  dropdownMaxHeight: 200,
                                                  dropdownWidth: 160,
                                                  dropdownPadding: null,
                                                  dropdownDecoration:
                                                      BoxDecoration(
                                                    border: Border.all(
                                                      color: myTheme
                                                          .colorScheme.primary,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    color: Colors.white,
                                                  ),
                                                  dropdownElevation: 0,
                                                  scrollbarRadius:
                                                      const Radius.circular(40),
                                                  scrollbarThickness: 6,
                                                  scrollbarAlwaysShow: true,
                                                  offset: const Offset(0, 0),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                // Cancelar
                                                Navigator.pop(context);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  myTheme.colorScheme.primary,
                                                ),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                ),
                                              ),
                                              icon: Icon(
                                                MaterialCommunityIcons
                                                    .backspace,
                                                size: 16,
                                              ),
                                              label: Text(
                                                'Cancelar',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins-regular',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                // Aplicar cambios de descuentos
                                                setState(
                                                  () {
                                                    discountByInput = int.parse(
                                                        selectedDiscount
                                                            .toString());
                                                  },
                                                );
                                                print(
                                                    'discountByInput: $discountByInput');
                                                Navigator.pop(context);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  myTheme.colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                ),
                                              ),
                                              icon: Icon(
                                                MaterialCommunityIcons
                                                    .label_percent,
                                                size: 20,
                                              ),
                                              label: Text(
                                                'Aceptar',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins-regular',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );

                                setState(() {});
                              },
                              splashRadius: 10,
                              splashColor: myTheme.colorScheme.primary,
                              icon: Icon(
                                MaterialIcons.add,
                                size: 16,
                                color: myTheme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '- ${priceFormat(totalDiscountApplied())}',
                        // 'test',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 12,
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
                        AppLocalizations.of(context)!.orderTotal,
                        style: TextStyle(
                          color: myTheme.colorScheme.onPrimaryContainer,
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${priceFormat(totalOfTheOrder)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.onPrimaryContainer,
                          fontFamily: 'Poppins-regular',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // if (amountPayed > 0)
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         alignment: Alignment.centerLeft,
                //         child: Text(
                //           'Monto Pagado',
                //           style: TextStyle(
                //             color: myTheme.colorScheme.onPrimaryContainer,
                //             fontFamily: 'Poppins-regular',
                //             fontSize: 14,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //       Container(
                //         margin: const EdgeInsets.only(bottom: 5),
                //         alignment: Alignment.centerRight,
                //         child: Text(
                //           priceFormat(amountPayed),
                //           style: TextStyle(
                //             color: myTheme.colorScheme.onPrimaryContainer,
                //             fontFamily: 'Poppins-regular',
                //             fontSize: 12,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 5),
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
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
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
                      contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
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
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ElevatedButton(
                onPressed: () async {
                  // Boton de procesar pago
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                          ),
                          title: Center(
                            child: Text(
                              'Confirmación',
                            ),
                          ),
                          content: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Center(
                                    child: Text(
                                      '¿Pasar a procesar pago?',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Cancelar
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      myTheme.colorScheme.primary,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    MaterialCommunityIcons.backspace,
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    // Aceptar e Iniciar el proceso de pago
                                    // Por pago directo
                                    final firebaseID = FirebaseFirestore
                                        .instance
                                        .collection('clientes')
                                        .doc(widget.client!.clientDocumentId)
                                        .collection('pedidos')
                                        .doc()
                                        .id;
                                    print('PAGO DIRECTO');
                                    final invoiceNumber =
                                        await completePaymentProcess(
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
                                            discountByInput,
                                            firebaseID);

                                    Client currentClient = Client(
                                      active: widget.client!.active,
                                      specialContributor:
                                          widget.client!.specialContributor,
                                      madeBy: widget.client!.madeBy,
                                      masterDiscount:
                                          widget.client!.masterDiscount,
                                      fiscalAdress: widget.client!.fiscalAdress,
                                      dispatchAdress:
                                          widget.client!.dispatchAdress,
                                      email: widget.client!.email,
                                      prices: widget.client!.prices,
                                      modified: widget.client!.modified,
                                      name: widget.client!.name,
                                      id: widget.client!.id,
                                      prospect: widget.client!.prospect,
                                      phone1: widget.client!.phone1,
                                      phone2: widget.client!.phone2,
                                      idType: widget.client!.idType,
                                      zone: widget.client!.zone,
                                      clientDocumentId:
                                          widget.client!.clientDocumentId,
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        settings:
                                            RouteSettings(name: 'PAGO-DIRECTO'),
                                        builder: (BuildContext context) =>
                                            AddPaymentPage(
                                          remaining: totalOfTheOrder,
                                          subTotal: widget.subTotal,
                                          discountPercentage: discountByInput,
                                          // discountPercentage:
                                          //     widget.client?.masterDiscount,
                                          discount: totalDiscountApplied(),
                                          // discount: (widget.subTotal / 100) *
                                          //     widget.client?.masterDiscount,
                                          tax: taxTotal,
                                          percentageTax: 16,
                                          client: currentClient,
                                          invoiceDocumentID: firebaseID,
                                          invoiceNumber: invoiceNumber,
                                          payments: [],
                                          // updatePayed: updatePayed,
                                        ),
                                      ),
                                    );

                                    print('PAGO REGISTRADO');
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      myTheme.colorScheme.onPrimaryContainer,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    MaterialCommunityIcons
                                        .contactless_payment_circle,
                                    size: 20,
                                  ),
                                  label: Text(
                                    'Continuar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myTheme.colorScheme.onPrimaryContainer,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PROCESAR PAGO ',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Icon(
                        MaterialIcons.payment,
                        size: 14,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ElevatedButton(
                onPressed: () async {
                  // Pop-up de confirmacion para guardar pedido
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                          ),
                          title: Center(
                            child: Text(
                              'Confirmación',
                            ),
                          ),
                          content: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Center(
                                    child: Text(
                                      '¿Seguro que quiere guardar el pedido y pagar de forma manual?',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Cancelar
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      myTheme.colorScheme.primary,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    MaterialCommunityIcons.backspace,
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    // Guardar pedido con el flujo
                                    // Por Distribución
                                    print('GUARDAR PEDIDO');
                                    final orderActive =
                                        Provider.of<OrderProvider>(context,
                                            listen: false);

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
                                        discountByInput,
                                      );
                                      orderActive.setOrder(false, Clients());
                                      completeOrder();
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Seleccione un tipo de Negociacion por favor');
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      myTheme.colorScheme.onPrimaryContainer,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    MaterialCommunityIcons.content_save,
                                    size: 20,
                                  ),
                                  label: Text(
                                    'Continuar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: myTheme.colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GUARDAR PEDIDO',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Icon(
                        MaterialIcons.save_alt,
                        // SimpleLineIcons.arrow_right,
                        size: 14,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        content: SingleChildScrollView(
                          child: Stack(
                            children: [
                              Container(
                                height: 400,
                                width: 300,
                                child: Opacity(
                                  opacity: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      'assets/images/payment-background.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(18),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "¡PAGO REGISTRADO!",
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          fontSize: 18,
                                          color: Colors.white,
                                          // color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        width: 100,
                                        height: 100,
                                        child: Opacity(
                                          opacity: 0.8,
                                          child: Image.asset(
                                            'assets/images/check.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                'Monto pagado: 00.00',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  fontSize: 12,
                                                  color: myTheme
                                                      .colorScheme.primary,
                                                  // color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                'ZONA TEST CLIENTE DEFAULT 000A1',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  fontSize: 12,
                                                  color: myTheme
                                                      .colorScheme.primary,
                                                  // color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                'Fecha: 00/00/0000',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  fontSize: 12,
                                                  color: myTheme
                                                      .colorScheme.primary,
                                                  // color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                'Deposito',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  fontSize: 12,
                                                  color: myTheme
                                                      .colorScheme.primary,
                                                  // color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 50),
                                        alignment: Alignment.center,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              myTheme.colorScheme.primary,
                                            ),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                            ),
                                          ),
                                          icon: Icon(
                                            MaterialIcons.arrow_back_ios,
                                            size: 12,
                                          ),
                                          label: Text(
                                            'Aceptar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins-regular',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Text('Test'))
        ],
      ),
    );
  }
}
