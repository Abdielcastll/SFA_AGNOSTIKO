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
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/completed_order.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_checkout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String? selectedValue2;
  String commentary = '';
  bool isFiscalSelected = true;
  var numberOrder;
  int discountByInput = 0;
  DateTime today = DateTime.now();
  DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

  final List<String> items = ['Fiscal', 'Despacho'];

  final List<String> items2 = ['Consignacion', 'Factura', 'Nota de entrega'];

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
          total: totalPriceOfTheOrder(),
          coinsExchangeRates: widget.coinsExchangeRates,
        ),
      ),
    );
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
                      child: Text(
                        'Descuento aplicado ($discountByInput%)',
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
                        // '${totalDiscountApplied()}',
                        'test',
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
              ],
            ),
          ),
          // Descuentos
          Container(
            // height: 150,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            // color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Text(
                    'Aplicar descuento',
                    style: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 5, 10, 0),
                      width: MediaQuery.of(context).size.width * 0.9,
                      // width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                      child: Material(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 16,
                            color: myTheme.colorScheme.primary,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          //  textAlign: TextAlign.center,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          maxLength: 3,
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                MaterialCommunityIcons.label_percent,
                                color: myTheme.colorScheme.primary,
                              ),
                              onPressed: () {
                                // Aplicar porcentaje
                                // discountByInput ??= 0;
                                if (discountByInput > 99) {
                                  Fluttertoast.showToast(
                                    msg:
                                        'El descuento no puede exceder del 99%',
                                    backgroundColor:
                                        myTheme.colorScheme.primary,
                                    textColor: Colors.white,
                                  );
                                }
                                print(discountByInput);
                              },
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(14, 0, 14, 0),
                            hintText: '% de descuento',
                            counterText: "",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color:
                                  myTheme.colorScheme.primary.withOpacity(0.4),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: myTheme.colorScheme.primary,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                discountByInput = 0;
                              } else {
                                discountByInput = int.parse(value);
                              }

                              // print(discountByInput);
                              // numberOrder = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          widget.client!.name.toString().contains('000A Cliente Default')
              ? Container(
                  // height: 50,
                  // width: MediaQuery.of(context).size.width,
                  // alignment: Alignment.center,
                  // margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  // child: Center(
                  //   child: Text(
                  //     'Dirección por defecto seleccionada',
                  //     style: TextStyle(
                  //       color: myTheme.colorScheme.primary,
                  //       fontFamily: 'Poppins-regular',
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  )
              : Container(
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
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Text(
                          AppLocalizations.of(context)!.orderDeliveryAddress,
                          style: TextStyle(
                            color: myTheme.colorScheme.primary,
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
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
                            buttonPadding:
                                const EdgeInsets.only(left: 14, right: 14),
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.3),
                              ),
                              color: Colors.white,
                            ),
                            buttonElevation: 0,
                            itemHeight: 40,
                            itemPadding:
                                const EdgeInsets.only(left: 14, right: 14),
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
                            offset: const Offset(0, 0),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                          style: const TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          widget.client!.name.toString().contains('000A Cliente Default')
              ? Container()
              : Container(
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
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!.orderNumber,
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
                            margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(10, 5, 0, 10),
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
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(14, 0, 14, 0),
                                  hintText: '0000',
                                  counterText: "",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: myTheme.colorScheme.primary
                                        .withOpacity(0.4),
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
                                },
                              ),
                            ),
                          ),
                          Icon(
                            Icons.numbers_rounded,
                            color: myTheme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 50),
                          Container(
                            height: 47,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.3),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                                SizedBox(
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
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  width: 300,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
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
                      offset: const Offset(0, 0),
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
          // widget.client!.name.toString().contains('000A Cliente Default')
          // ?
          // Container(
          //     margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //     width: MediaQuery.of(context).size.width,
          //     height: 50,
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(16),
          //       child: ElevatedButton(
          //         onPressed: () async {
          //           // Pasar de una vez a pantalla de pago
          //         },
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: myTheme.colorScheme.primary,
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             const Text(
          //               'FACTURAR',
          //               style: TextStyle(
          //                 fontFamily: 'Poppins-regular',
          //                 fontSize: 14,
          //               ),
          //             ),
          //             Container(
          //               margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
          //               child: Icon(
          //                 SimpleLineIcons.arrow_right,
          //                 size: 14,
          //                 color: Colors.grey.shade300,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   )
          // :
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
                  // final orderActive =
                  //     Provider.of<OrderProvider>(context, listen: false);

                  // if (selectedValue2 != null) {
                  //   var result = await createOrder(
                  //     widget.client,
                  //     userUid,
                  //     commentary,
                  //     masterDiscountTotal,
                  //     widget.cart,
                  //     selectedValue2,
                  //     selectedValue,
                  //     today,
                  //     taxTotal,
                  //     numberOrder,
                  //     widget.subTotal,
                  //     totalOfTheOrder,
                  //   );
                  //   orderActive.setOrder(false, Clients());
                  //   completeOrder();
                  // } else {
                  //   Fluttertoast.showToast(
                  //       msg: 'Seleccione un tipo de Negociacion por favor');
                  // }
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
                  final orderActive =
                      Provider.of<OrderProvider>(context, listen: false);

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
                    orderActive.setOrder(false, Clients());
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
                      widget.client!.name
                              .toString()
                              .contains('000A Cliente Default')
                          ? 'GUARDAR FACTURA'
                          : 'CONTINUAR',
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
