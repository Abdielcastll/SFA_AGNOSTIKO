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
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/objectbox.g.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
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
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_checkout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutRetailPage extends StatefulWidget {
  const CheckoutRetailPage({
    Key? key,
    required this.client,
    required this.cart,
    required this.subTotal,
  }) : super(key: key);

  final Clients? client;
  final List<ShoppingCartProduct> cart;
  final double subTotal;

  @override
  State<CheckoutRetailPage> createState() => _CheckoutRetailPageState();
}

class _CheckoutRetailPageState extends State<CheckoutRetailPage> {
  @override
  Widget build(BuildContext context) {
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;
    return Scaffold(
      appBar: const AppBarCheckout(),
      backgroundColor: Colors.grey.shade100,
      body: MultiProvider(
        providers: [
          StreamProvider<Coin?>.value(
            initialData: Coin(),
            catchError: (context, error) {
              print(
                  'ERROR ON STREAM PROVIDER OF COINEXCHANGE RATES IN ADD CLIENT');
              print(error);
              return;
            },
            value: coinCollection
                .doc(currentCoinSelectedCode)
                .snapshots()
                .map(coinFromSnapshot),
          ),
        ],
        child: CheckoutBody(
          client: widget.client,
          subTotal: widget.subTotal,
          cart: widget.cart,
        ),
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
  }) : super(key: key);

  final Clients? client;
  final double subTotal;
  final List<ShoppingCartProduct> cart;

  @override
  State<CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  String? selectedValue = 'Fiscal';
  String? selectedValue2 = 'Factura';
  String? selectedDiscount = '0';
  String commentary = '';
  bool isFiscalSelected = true;
  var numberOrder;
  int discountByInput = 0;
  DateTime today = DateTime.now();
  DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

  final List<String> items = ['Fiscal', 'Despacho'];

  final List<String> items2 = ['Factura', 'Consignacion', 'Nota de entrega'];

  @override
  Widget build(BuildContext context) {
    final userUid = Provider.of<UserModel>(context).uid;
    int? clientMasterDiscount = widget.client?.masterDiscount;
    String? fiscalAddress = widget.client?.fiscalAdress;
    String? dispatchAddress =
        widget.client?.dispatchAdress ?? 'No Hay direcciofn disponible';
    String formattedDate = dateFormatter.format(today);
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    final coinName = Provider.of<Coin?>(context)?.name ?? '';
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
    final coinCode = Provider.of<Coin?>(context)?.code ?? '';
    print('TEStiNG COIN NAME');
    print(coinName);

    double subTotalConverted = priceMultipliedByItsExchangeRatio(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: widget.subTotal);
    print('subTotal: ${widget.subTotal}');
    print('subTotalConverted: $subTotalConverted');

    double subTotalWithMasterDiscount = double.parse(
        (widget.subTotal * (widget.client?.masterDiscount / 100))
            .toStringAsFixed(4));
    double subTotalWithMasterDiscountConverted =
        priceMultipliedByItsExchangeRatio(
            coinDecimals: coinDecimals,
            coinExchangeRatio: coinExchangeRatio,
            productPrice: subTotalWithMasterDiscount);
    print('subTotalWithMasterDiscount: $subTotalWithMasterDiscount');
    print(
        'subTotalWithMasterDiscountConverted: $subTotalWithMasterDiscountConverted');

    double subTotalWithDiscountApplied = double.parse(
        (widget.subTotal * (discountByInput / 100)).toStringAsFixed(4));
    double subTotalWithDiscountAppliedConverted =
        priceMultipliedByItsExchangeRatio(
            coinDecimals: coinDecimals,
            coinExchangeRatio: coinExchangeRatio,
            productPrice: subTotalWithDiscountApplied);
    print('subTotalWithDiscountApplied: $subTotalWithDiscountApplied');
    print(
        'subTotalWithDiscountAppliedConverted: $subTotalWithDiscountAppliedConverted');

    double getIVA = double.parse(
      ((widget.subTotal -
                  subTotalWithMasterDiscount -
                  subTotalWithDiscountApplied) *
              (16 / 100))
          .toStringAsFixed(4),
    );
    double getIVAConverted = priceMultipliedByItsExchangeRatio(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: getIVA);
    print('getIVA: $getIVA');
    print('getIVAConverted: $getIVAConverted');

    double totalPriceOfTheOrder = double.parse((widget.subTotal -
            subTotalWithMasterDiscount -
            subTotalWithDiscountApplied +
            getIVA)
        .toStringAsFixed(4));
    double totalPriceOfTheOrderConverted = priceMultipliedByItsExchangeRatio(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: totalPriceOfTheOrder);
    print('totalPriceOfTheOrder: $totalPriceOfTheOrder');
    print('totalPriceOfTheOrderConverted: $totalPriceOfTheOrderConverted');

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
            total: totalPriceOfTheOrder,
            completedMessage: '¡Pedido guardado!',
          ),
        ),
      );
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
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$coinSymbol ${subTotalConverted.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
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
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '- $coinSymbol ${subTotalWithMasterDiscountConverted.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
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
                      // margin: const EdgeInsets.only(bottom: 5),
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
                                                  iconStyleData: IconStyleData(
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
                                                  ),
                                                  buttonStyleData:
                                                      ButtonStyleData(
                                                    height: 50,
                                                    width: 160,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 14,
                                                            right: 14),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      border: Border.all(
                                                        color: myTheme
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  menuItemStyleData:
                                                      MenuItemStyleData(
                                                    height: 40,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 14,
                                                            right: 14),
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    width: 160,
                                                    padding: null,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: myTheme
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      color: Colors.white,
                                                    ),
                                                    elevation: 0,
                                                    scrollbarTheme:
                                                        ScrollbarThemeData(
                                                      radius:
                                                          const Radius.circular(
                                                              40),
                                                      thickness:
                                                          MaterialStateProperty
                                                              .all<double>(6),
                                                      thumbVisibility:
                                                          MaterialStateProperty
                                                              .all<bool>(true),
                                                    ),
                                                    maxHeight: 200,
                                                    offset: const Offset(0, 0),
                                                  ),
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
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '- $coinSymbol ${subTotalWithDiscountAppliedConverted.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
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
                      margin: const EdgeInsets.only(bottom: 10),
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
                      margin: const EdgeInsets.only(bottom: 10, right: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '+ $coinSymbol ${getIVAConverted.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
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
                      margin: const EdgeInsets.only(bottom: 5, right: 10),
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$coinSymbol ${totalPriceOfTheOrderConverted.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: myTheme.colorScheme.onPrimaryContainer,
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
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
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                    print('Iniciar proceso de pago directo');

                                    final firebaseID = FirebaseFirestore
                                        .instance
                                        .collection('clientes')
                                        .doc(widget.client!.clientDocumentId)
                                        .collection('pedidos')
                                        .doc()
                                        .id;

                                    print(firebaseID);

                                    final invoiceNumber =
                                        await completePaymentProcess(
                                      widget.client,
                                      userUid,
                                      commentary,
                                      subTotalWithMasterDiscount,
                                      widget.cart,
                                      selectedValue2,
                                      selectedValue,
                                      today,
                                      getIVA,
                                      numberOrder,
                                      widget.subTotal,
                                      totalPriceOfTheOrder,
                                      discountByInput,
                                      firebaseID,
                                    );

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
                                          invoiceTotal: totalPriceOfTheOrder,
                                          remaining: totalPriceOfTheOrder,
                                          subTotal: widget.subTotal,
                                          discountPercentage: discountByInput,
                                          // discountPercentage:
                                          //     widget.client?.masterDiscount,
                                          discount: subTotalWithDiscountApplied,
                                          // discount: (widget.subTotal / 100) *
                                          //     widget.client?.masterDiscount,
                                          tax: getIVA,
                                          percentageTax: 16,
                                          client: currentClient,
                                          invoiceDocumentID: firebaseID,
                                          invoiceNumber: invoiceNumber,
                                          payments: [],
                                          // updatePayed: updatePayed,
                                        ),
                                      ),
                                    );
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
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
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
                                    print('GUARDAR PEDIDO');
                                    final orderActive =
                                        Provider.of<OrderProvider>(context,
                                            listen: false);

                                    if (selectedValue2 != null) {
                                      try {
                                        var result = await createOrder(
                                          widget.client,
                                          userUid,
                                          commentary,
                                          subTotalWithMasterDiscount,
                                          widget.cart,
                                          selectedValue2,
                                          selectedValue,
                                          today,
                                          getIVA,
                                          numberOrder,
                                          widget.subTotal,
                                          totalPriceOfTheOrder,
                                          discountByInput,
                                        );
                                      } catch (e) {
                                        print('ERROR AL GUARDAR PEDIDO');
                                        print(e);
                                      }
                                      orderActive.setOrder(false, Clients());
                                      objectBox.delelteAllShoppingCart();
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
        ],
      ),
    );
  }
}
