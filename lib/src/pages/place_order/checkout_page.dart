// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/discount.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/completed_order.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_checkout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    Key? key,
    required this.client,
    required this.cart,
    required this.subTotal,
  }) : super(key: key);

  final Clients? client;
  final List<ShoppingCartProduct> cart;
  final double subTotal;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;
    return Scaffold(
      appBar: const AppBarCheckout(),
      backgroundColor: myTheme.colorScheme.background,
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
  DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

  final List<String> items = ['Fiscal', 'Despacho'];

  final List<String> items2 = ['Factura', 'Consignacion', 'Nota de entrega'];

  @override
  Widget build(BuildContext context) {
    print('OPENING CHECKOUT PAGE');
    final userUid = Provider.of<UserModel>(context).uid;
    int? clientMasterDiscount = widget.client?.masterDiscount;
    String? fiscalAddress = widget.client?.fiscalAdress;
    String? dispatchAddress =
        widget.client?.dispatchAdress ?? 'No Hay direccion disponible';
    String formattedDate = dateFormatter.format(today);
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    final coinName = Provider.of<Coin?>(context)?.name ?? '';
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
    final coinCode = Provider.of<Coin?>(context)?.code ?? '';

    // SUB TOTAL

    var subTotalConverted = priceMultipliedByItsExchangeRatio2(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: widget.subTotal);
    print('subTotal: ${widget.subTotal}');
    print('subTotalConverted: $subTotalConverted');

    var subTotalFormatted =
        formatDecimalPriceByRegion(price: subTotalConverted);
    print('subTotalFormatted: $subTotalFormatted');

    // DESCUENTO MAESTRO

    var subTotalWithMasterDiscountRaw =
        ((Decimal.parse(widget.subTotal.toString()) *
                    Decimal.parse(
                        widget.client?.masterDiscount.toString() ?? '0')) /
                Decimal.parse('100'))
            // .toDecimal();
            .toDouble();
    print('subTotalWithMasterDiscountRaw: $subTotalWithMasterDiscountRaw');

    var subTotalWithMasterDiscountRounded = Decimal.parse(
        ((Decimal.parse(subTotalWithMasterDiscountRaw.toString()) *
                        Decimal.parse('100'))
                    .round() /
                Decimal.parse('100'))
            // .toDecimal()
            .toDouble()
            .toString());
    print(
        'subTotalWithMasterDiscountRounded: $subTotalWithMasterDiscountRounded');

    var subTotalWithMasterDiscountConverted =
        priceMultipliedByItsExchangeRatio2(
            coinDecimals: coinDecimals,
            coinExchangeRatio: coinExchangeRatio,
            productPrice: subTotalWithMasterDiscountRounded);
    print(
        'subTotalWithMasterDiscountConverted: $subTotalWithMasterDiscountConverted');

    var subTotalWithMasterDiscountFormatted =
        formatDecimalPriceByRegion(price: subTotalWithMasterDiscountConverted);
    print(
        'subTotalWithMasterDiscountFormatted: $subTotalWithMasterDiscountFormatted');

    // DESCUENTO APLICADO

    var discountAppliedRaw = (((Decimal.parse(subTotalConverted.toString()) -
                    Decimal.parse(
                        subTotalWithMasterDiscountRounded.toString())) *
                Decimal.parse(discountByInput.toString())) /
            Decimal.parse('100'))
        // .toDecimal();
        .toDouble();
    print('discountAppliedRaw: $discountAppliedRaw');

    var discountAppliedRounded = Decimal.parse(
        ((Decimal.parse(discountAppliedRaw.toString()) * Decimal.parse('100'))
                    .round() /
                Decimal.parse('100'))
            // .toDecimal()
            .toDouble()
            .toString());
    print('discountAppliedRounded: $discountAppliedRounded');

    var discountAppliedConverted = priceMultipliedByItsExchangeRatio2(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: discountAppliedRounded);
    print('discountAppliedConverted: $discountAppliedConverted');

    var discountAppliedFormatted =
        formatDecimalPriceByRegion(price: discountAppliedConverted);
    print('discountAppliedFormatted: $discountAppliedFormatted');

    // ACUMULADO

    var accumulated = Decimal.parse(widget.subTotal.toString()) -
        Decimal.parse(subTotalWithMasterDiscountRounded.toString()) -
        Decimal.parse(discountAppliedRounded.toString());

    print('accumulated: ${accumulated}');

    // TAXES

    var taxRaw =
        ((Decimal.parse(accumulated.toString()) * Decimal.parse('16')) /
                Decimal.parse('100'))
            // .toDecimal();
            .toDouble();

    print('taxRaw: $taxRaw');

    var taxRounded = Decimal.parse(
        ((Decimal.parse(taxRaw.toString()) * Decimal.parse('100')).round() /
                Decimal.parse('100'))
            // .toDecimal()
            .toDouble()
            .toString());

    print('taxRounded: $taxRounded');
    print('resultado');
    print(Decimal.parse(accumulated.toString()) +
        Decimal.parse(taxRounded.toString()));

    var taxConverted = priceMultipliedByItsExchangeRatio2(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: taxRounded);

    print('taxConverted: $taxConverted');

    var taxFormatted = formatDecimalPriceByRegion(price: taxConverted);
    print('taxFormatted: $taxFormatted');

    // TOTAL DEL PEDIDO

    var totalPriceOfTheOrder = Decimal.parse(accumulated.toString()) +
        Decimal.parse(taxRounded.toString());

    print('totalPriceOfTheOrderRaw: $totalPriceOfTheOrder');

    var totalPriceOfTheOrderConverted = priceMultipliedByItsExchangeRatio2(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: totalPriceOfTheOrder);

    print('totalPriceOfTheOrderConverted: $totalPriceOfTheOrderConverted');

    var totalPriceOfTheOrderFormatted =
        formatDecimalPriceByRegion(price: totalPriceOfTheOrderConverted);

    print('totalPriceOfTheOrderFormatted: $totalPriceOfTheOrderFormatted');

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
            completedMessage: '¡Pedido Completado!',
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
                        '$coinSymbol $subTotalFormatted',
                        // '0',
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
                        // '0',
                        '- $coinSymbol $subTotalWithMasterDiscountFormatted',
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
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                          maxHeight: 200,
                                                          width: 160,
                                                          padding: null,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: myTheme
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14),
                                                            color: Colors.white,
                                                          ),
                                                          elevation: 0,
                                                          offset: const Offset(
                                                              0, 0),
                                                          scrollbarTheme:
                                                              ScrollbarThemeData(
                                                            radius: const Radius
                                                                .circular(40),
                                                            thickness:
                                                                MaterialStateProperty
                                                                    .all<double>(
                                                                        6),
                                                            thumbVisibility:
                                                                MaterialStateProperty
                                                                    .all<bool>(
                                                                        true),
                                                          )),
                                                  menuItemStyleData:
                                                      MenuItemStyleData(
                                                    height: 40,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 14,
                                                            right: 14),
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
                      margin: const EdgeInsets.only(bottom: 5),
                      alignment: Alignment.centerRight,
                      child: Text(
                        // '0',
                        '- $coinSymbol $discountAppliedFormatted',
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
                        // '0',
                        '+ $coinSymbol $taxFormatted',
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
                        // '0',
                        '$coinSymbol $totalPriceOfTheOrderFormatted',
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
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                  margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                  child: Text(
                    AppLocalizations.of(context)!.orderDeliveryAddress,
                    style: TextStyle(
                      color: Color(0xFF4353C2),
                      fontFamily: 'Poppins-medium',
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$selectedValue',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4353C2),
                                fontFamily: 'Poppins-medium',
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
                                  color: Color(0xFF4353C2),
                                  fontFamily: 'Poppins-medium',
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
                          },
                        );
                      },
                      iconStyleData: IconStyleData(
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFFDFE0FF),
                        ),
                        iconSize: 24,
                        iconEnabledColor: Color(0xFFDFE0FF),
                        iconDisabledColor: Colors.grey,
                      ),
                      buttonStyleData: ButtonStyleData(
                        height: 56,
                        width: 180,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xFFDFE0FF),
                          ),
                          color: Colors.white,
                        ),
                        elevation: 0,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: 40,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 180,
                        padding: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        elevation: 1,
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(8),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
                        ),
                        offset: const Offset(0, 0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(0xFFDFE0FF),
                    ),
                  ),
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    isFiscalSelected
                        ? widget.client?.fiscalAdress
                        : widget.client?.dispatchAdress,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4353C2),
                      fontFamily: 'Poppins-medium',
                    ),
                  ),
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
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.orderNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4353C2),
                            fontFamily: 'Poppins-medium',
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Fecha de Entrega',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4353C2),
                            fontFamily: 'Poppins-medium',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      margin: const EdgeInsets.fromLTRB(16, 5, 0, 10),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4353C2),
                          fontFamily: 'Poppins-medium',
                        ),
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        maxLength: 10,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(14, 0, 14, 0),
                          hintText: '0000',
                          counterText: "",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFDFE0FF),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFFDFE0FF),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFFDFE0FF),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFFDFE0FF),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            numberOrder = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 150,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xFFDFE0FF),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
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
                          IconButton(
                            onPressed: () async {
                              // Seleccionar fecha
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: today,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2050),
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
                              size: 16,
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
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                  margin: const EdgeInsets.fromLTRB(16, 0, 160, 0),
                  child: Text(
                    'Tipo de negociacion',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4353C2),
                      fontFamily: 'Poppins-medium',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 10, 10),
                  width: 300,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$selectedValue2',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4353C2),
                                fontFamily: 'Poppins-medium',
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
                                    color: Color(0xFF4353C2),
                                    fontFamily: 'Poppins-medium',
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
                      iconStyleData: IconStyleData(
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        iconSize: 24,
                        iconEnabledColor: Color(0xFFDFE0FF),
                        iconDisabledColor: Colors.grey,
                      ),
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 150,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xFFDFE0FF),
                          ),
                          color: Colors.white,
                        ),
                        elevation: 0,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: 40,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 300,
                        padding: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        elevation: 1,
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(8),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
                        ),
                        offset: const Offset(0, 0),
                      ),
                    ),
                  ),
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
                      color: Color(0xFF4353C2),
                      fontFamily: 'Poppins-medium',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFDFE0FF),
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 200,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      hintText: 'Comentario sobre la entrega',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFDFE0FF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFFDFE0FF),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFFDFE0FF),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFFDFE0FF),
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
                                      '¿Ha verificado todos los datos para proseguir con el pedido?',
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
                                    print('GUARDAR PEDIDO INICIADO');
                                    final orderActive =
                                        Provider.of<OrderProvider>(context,
                                            listen: false);
                                    final double subTotalToDouble =
                                        widget.subTotal;
                                    final double masterDiscount =
                                        subTotalWithMasterDiscountRounded
                                            .toDouble();
                                    final double appliedDiscount =
                                        discountAppliedRounded.toDouble();
                                    final double taxes = taxRounded.toDouble();
                                    final double total =
                                        totalPriceOfTheOrder.toDouble();

                                    print('subTotalToDouble:$subTotalToDouble');
                                    print('masterDiscount:$masterDiscount');
                                    print('appliedDiscount:$appliedDiscount');
                                    print('taxes:$taxes');
                                    print('total:$total');

                                    if (selectedValue2 != null) {
                                      var result = await createOrder(
                                        widget.client,
                                        userUid,
                                        commentary,
                                        masterDiscount,
                                        widget.cart,
                                        selectedValue2,
                                        selectedValue,
                                        today,
                                        taxes,
                                        numberOrder,
                                        subTotalToDouble,
                                        total,
                                        discountByInput,
                                        false,
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
                    SizedBox(),
                    Text(
                      'Completar Pedido',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      size: 24,
                      color: Color(0xFFDFE0FF),
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
