// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_checkout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/identify_payment_method.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/identify_payment_method_retail.dart';

import '../../models/clients_model.dart';

class AddPaymentPage extends StatefulWidget {
  AddPaymentPage({
    super.key,
    required this.remaining,
    required this.subTotal,
    required this.discountPercentage,
    required this.discount,
    required this.tax,
    required this.percentageTax,
    required this.invoiceDocumentID,
    required this.client,
    required this.invoiceNumber,
    required this.payments,
    this.amountPayed,

    // required this.updatePayed,
  });

  final double remaining;
  final double subTotal;
  final int discountPercentage;
  final double discount;
  final double tax;
  final int percentageTax;
  final String invoiceDocumentID;
  final Client client;
  final int invoiceNumber;
  List<PayMethod> payments;
  double? amountPayed;

  // final Function(double) updatePayed;

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCheckout(),
      backgroundColor: Colors.grey.shade100,
      body: AddPaymentBody(
        remaining: widget.remaining,
        subTotal: widget.subTotal,
        discount: widget.discount,
        discountPercentage: widget.discountPercentage,
        tax: widget.tax,
        percentageTax: widget.percentageTax,
        client: widget.client,
        invoiceDocumentID: widget.invoiceDocumentID,
        amountPayed: widget.amountPayed,
        invoiceNumber: widget.invoiceNumber,
        payments: widget.payments,
        // updatePayed: widget.updatePayed,
      ),
    );
  }
}

class AddPaymentBody extends StatefulWidget {
  AddPaymentBody({
    super.key,
    required this.remaining,
    required this.subTotal,
    required this.discountPercentage,
    required this.discount,
    required this.tax,
    required this.percentageTax,
    required this.invoiceDocumentID,
    required this.client,
    required this.invoiceNumber,
    required this.payments,
    this.amountPayed,

    // required this.updatePayed,
  });

  final double remaining;
  final double subTotal;
  final int discountPercentage;
  final double discount;
  final double tax;
  final int percentageTax;
  final String invoiceDocumentID;
  final Client client;
  final int invoiceNumber;
  List<PayMethod> payments;
  double? amountPayed;

  // final Function(double) updatePayed;

  @override
  State<AddPaymentBody> createState() => _AddPaymentBodyState();
}

class _AddPaymentBodyState extends State<AddPaymentBody> {
  late double remaining = widget.remaining;
  late double amountToPay = widget.remaining;
  bool amountChanged = false;
  late List<PayMethod> payments = widget.payments;
  double amountPayed = 0;
  final fieldText = TextEditingController();

  get getTotalAmount => widget.subTotal + widget.tax - widget.discount;

  var dateFormatter = DateFormat('dd-MM-yyyy');
  DateTime today = DateTime.now();
  String? selectedValueA;
  String? selectedCoin = 'MXN';
  final List<String> items = [
    'Tarjeta de Debito',
    'Tarjeta de Credito',
    'Efectivo',
    'Cheque',
    'Deposito',
    'Transferencia',
    'Transf-internacional',
    // 'Criptomoneda',
    // 'Nota de credito',
  ];
  List<String> itemsCoin = [
    'USD',
    // 'BTC',
    // 'EUR',
    // 'VED',
    'MXN',
  ];

  updatePayed(double amount) {
    print('payed $amount');
    if (amount != null && amount != 0) {
      setState(() {
        amountPayed += amount;
      });
    }
  }

  @override
  void initState() {
    amountPayed = widget.amountPayed ?? 0;
    super.initState();
  }

  priceToCurrencySelected(double productPrice, String coin) {
    double correctAmount = double.parse(productPrice.toStringAsFixed(4));
    if (coin.contains('USD')) {
      return correctAmount;
    } else if (coin.contains('VED')) {
      return correctAmount * 4.58;
    } else if (coin.contains('EUR')) {
      return correctAmount * 0.89;
    } else if (coin.contains('MXN')) {
      return correctAmount * 19.43;
    } else if (coin.contains('BTC')) {
      return correctAmount * 0.00011;
    } else {
      return correctAmount * 4.58;
    }
  }

  @override
  Widget build(BuildContext context) {
    double? paymentsTotalAmount = 0;
    for (var payment in widget.payments) {
      paymentsTotalAmount = paymentsTotalAmount! + payment.amount;
    }
    print('paymentsTotalAmount: $paymentsTotalAmount');
    print('Remaining on retail: ${remaining}');
    print('Amount on retail: ${amountToPay}');

    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    String formattedDate = dateFormatter.format(today);

    print('Current coin $currentCoin');

    priceFormat(productPrice) {
      if (productPrice is String) {
        productPrice = double.parse(productPrice.replaceAll('\$', ''));
      }
      double correctAmount = double.parse(productPrice.toStringAsFixed(4));
      if (currentCoin!.contains('USD')) {
        return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
            .format(productPrice)
            .toString();
      } else if (currentCoin.contains('VED')) {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "Bs.",
        ).format(correctAmount * 4.58).toString();
      } else if (currentCoin.contains('EUR')) {
        return NumberFormat.currency(
          locale: 'es_ES',
          decimalDigits: 2,
          symbol: '€',
        ).format(correctAmount * 0.89).toString();
      } else if (currentCoin.contains('MXN')) {
        return NumberFormat.currency(
          locale: 'es_MX',
          decimalDigits: 2,
          symbol: '\$',
        ).format(correctAmount * 19.43);
      } else if (currentCoin.contains('BTC')) {
        return '฿ ${(correctAmount * 0.00011).toString()}';
      } else {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "PPR.",
        ).format(correctAmount * 4.58).toString();
      }
    }

    priceFormatForPaidAmount(productPrice, coin) {
      print('Coin $coin');
      print('productPrice $productPrice');

      if (productPrice is String) {
        productPrice = double.parse(productPrice.replaceAll('\$', ''));
      }

      coin ??= 'Dolares - USD';
      double correctAmount = double.parse(productPrice.toStringAsFixed(4));
      if (coin!.contains('USD')) {
        return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
            .format(productPrice)
            .toString();
      } else if (coin.contains('VED')) {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "Bs.",
        ).format(correctAmount * 4.58).toString();
      } else if (coin.contains('EUR')) {
        return NumberFormat.currency(
          locale: 'es_ES',
          decimalDigits: 2,
          symbol: '€',
        ).format(correctAmount * 0.89).toString();
      } else if (coin.contains('MXN')) {
        return NumberFormat.currency(
          locale: 'es_MX',
          decimalDigits: 2,
          symbol: '\$',
        ).format(correctAmount * 19.43);
      } else if (coin.contains('BTC')) {
        return '฿ ${(correctAmount * 0.00011).toString()}';
      } else {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "PPR.",
        ).format(correctAmount * 4.58).toString();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName('ORDER'));
        return true;
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Center(
              child: Text(
                'Añadir Pago',
              ),
            ),
          ),
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    // Metodo de pago
                    AppLocalizations.of(context)!.paymentMethod,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      color: Color.fromARGB(255, 0, 24, 143),
                      fontSize: 14,
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
                                selectedValueA ?? 'Seleccione medio de pago',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(46, 62, 174, 1)
                                      .withOpacity(0.3),
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
                        value: selectedValueA,
                        onChanged: (value) {
                          setState(
                            () {
                              selectedValueA = value as String;
                            },
                          );
                          print(selectedValueA);
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                        iconSize: 11,
                        iconEnabledColor:
                            myTheme.colorScheme.primary.withOpacity(0.5),
                        iconDisabledColor: Colors.grey,
                        buttonHeight: 50,
                        // buttonWidth: 200,
                        buttonPadding:
                            const EdgeInsets.only(left: 14, right: 14),
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
                        dropdownMaxHeight: 300,
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
                        offset: const Offset(60, 0),
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  //   child: DropdownButtonHideUnderline(
                  //     child: DropdownButton2(
                  //       isExpanded: true,
                  //       // ignore: prefer_const_literals_to_create_immutables
                  //       hint: Row(
                  //         children: [
                  //           Expanded(
                  //             child: Text(
                  //               selectedCoin ?? 'Seleccione moneda',
                  //               style: TextStyle(
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.bold,
                  //                 color: myTheme.colorScheme.primary
                  //                     .withOpacity(0.3),
                  //               ),
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       items: itemsCoin
                  //           .map((item) => DropdownMenuItem<String>(
                  //                 value: item,
                  //                 child: Text(
                  //                   item,
                  //                   style: TextStyle(
                  //                     fontSize: 14,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: myTheme.colorScheme.primary,
                  //                   ),
                  //                   overflow: TextOverflow.ellipsis,
                  //                 ),
                  //               ))
                  //           .toList(),
                  //       value: selectedCoin,
                  //       onChanged: (value) {
                  //         // Pendiente
                  //         // fieldText.clear();

                  //         setState(
                  //           () {
                  //             selectedCoin = value as String;
                  //           },
                  //         );
                  //       },
                  //       icon: const Icon(
                  //         Icons.arrow_forward_ios_outlined,
                  //       ),
                  //       iconSize: 11,
                  //       iconEnabledColor:
                  //           myTheme.colorScheme.primary.withOpacity(0.5),
                  //       iconDisabledColor: Colors.grey,
                  //       buttonHeight: 50,
                  //       // buttonWidth: 200,
                  //       buttonPadding:
                  //           const EdgeInsets.only(left: 14, right: 14),
                  //       buttonDecoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(5),
                  //         border: Border.all(
                  //           color: myTheme.colorScheme.primary.withOpacity(0.3),
                  //         ),
                  //         color: Colors.white,
                  //       ),
                  //       buttonElevation: 0,
                  //       itemHeight: 40,
                  //       itemPadding: const EdgeInsets.only(left: 14, right: 14),
                  //       dropdownMaxHeight: 200,
                  //       dropdownWidth: 200,
                  //       dropdownPadding: null,
                  //       dropdownDecoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: Colors.white,
                  //       ),
                  //       dropdownElevation: 8,
                  //       scrollbarRadius: const Radius.circular(10),
                  //       scrollbarThickness: 6,
                  //       scrollbarAlwaysShow: true,
                  //       offset: const Offset(60, 0),
                  //     ),
                  //   ),
                  // ),

                  // Fecha del registro del pago
                  Text(
                    AppLocalizations.of(context)!.date,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      color: myTheme.colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: myTheme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: myTheme.colorScheme.primary.withOpacity(0.7),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: IconButton(
                            onPressed: () async {
                              if (selectedValueA?.contains('Tarjeta') == true) {
                                today = DateTime.now();
                                return;
                              }
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: today,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2500),
                              );
                              if (newDate == null) {
                                return;
                              }
                              setState(() {
                                today = newDate;
                                formattedDate = dateFormatter.format(today);
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
                  // Monto Pagado
                  selectedValueA != null
                      ? Container()
                      : Column(
                          children: [
                            if (amountPayed > 0)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Saldo',
                                          style: TextStyle(
                                            color: myTheme
                                                .colorScheme.onPrimaryContainer,
                                            fontFamily: 'Poppins-regular',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Monto Pagado',
                                          style: TextStyle(
                                            color: myTheme
                                                .colorScheme.onPrimaryContainer,
                                            fontFamily: 'Poppins-regular',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          priceFormatForPaidAmount(
                                              remaining, selectedCoin),
                                          // priceFormat(priceFormatForPaidAmount(
                                          //     remaining, selectedCoin)),
                                          style: TextStyle(
                                            color: myTheme
                                                .colorScheme.onPrimaryContainer,
                                            fontFamily: 'Poppins-regular',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          priceFormat(paymentsTotalAmount),
                                          style: TextStyle(
                                            color: myTheme
                                                .colorScheme.onPrimaryContainer,
                                            fontFamily: 'Poppins-regular',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          ],
                        ),
                  selectedCoin == null
                      ? Container()
                      : Text(
                          '${AppLocalizations.of(context)!.amount}*',
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            color: myTheme.colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),

                  selectedCoin == null
                      ? Container()
                      : Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          height: 50,
                          // width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  myTheme.colorScheme.primary.withOpacity(0.3),
                              // color: Colors.transparent,
                            ),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              // VERIFICAR SI SE VUELVE NULLABLE

                              if (value.isEmpty) {
                                setState(() {
                                  amountToPay = 0;
                                  print(amountToPay);
                                });
                              } else {
                                setState(() {
                                  amountToPay = double.parse(value);
                                  print('amountToPay');
                                  print(amountToPay);
                                });
                              }
                              setState(() {
                                amountChanged = true;
                              });
                            },
                            controller: fieldText,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.primary,
                            ),
                            //TODO:
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
                              ),
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) => newValue.copyWith(
                                  text: newValue.text.replaceAll(',', '.'),
                                ),
                              ),
                            ],
                            keyboardType: TextInputType.phone,

                            maxLines: 1,
                            maxLength: 50,
                            textCapitalization: TextCapitalization.characters,

                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                14,
                                0,
                                0,
                                0,
                              ),
                              // priceFormatForPaidAmount(remaining, selectedCoin),
                              hintText: priceFormatForPaidAmount(
                                      double.parse(remaining == 0
                                          ? '0.00'
                                          : remaining.toStringAsFixed(4)),
                                      selectedCoin)
                                  .toString(),
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                color: myTheme.colorScheme.primary,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                  selectedCoin != null
                      ? selectedValueA != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    50,
                                    10,
                                    50,
                                    0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Subtotal:',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        priceFormatForPaidAmount(
                                                widget.subTotal, selectedCoin)
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    50,
                                    0,
                                    50,
                                    0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Descuento Aplicado (${widget.discountPercentage}%):',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        priceFormatForPaidAmount(
                                                widget.discount, selectedCoin)
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    50,
                                    0,
                                    50,
                                    0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'IVA (${widget.percentageTax}%):',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        priceFormatForPaidAmount(
                                                widget.tax, selectedCoin)
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    50,
                                    10,
                                    50,
                                    0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        // Aqui va widget.InvoiceTotal pero hay
                                        // que consultar si primero se va a
                                        // pagar completo o por partes aca
                                        'Total:',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        // Aqui va widget.InvoiceTotal pero hay
                                        // que consultar si primero se va a
                                        // pagar completo o por partes aca
                                        priceFormatForPaidAmount(
                                                double.parse((widget.subTotal)
                                                        .toStringAsFixed(4)) +
                                                    double.parse((widget.tax)
                                                        .toStringAsFixed(4)) -
                                                    double.parse((widget
                                                            .discount)
                                                        .toStringAsFixed(4)),
                                                selectedCoin)
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (amountPayed > 0)
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                      50,
                                      10,
                                      50,
                                      0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Monto pagado:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: myTheme
                                                .colorScheme.onPrimaryContainer,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          priceFormat(paymentsTotalAmount),
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: myTheme
                                                .colorScheme.onPrimaryContainer,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 5),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                    50,
                                    10,
                                    50,
                                    0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Saldo:',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme
                                              .colorScheme.onPrimaryContainer,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        // 'Saldo: ${priceFormatForPaidAmount(remaining.toStringAsFixed(4), selectedCoin)}',
                                        priceFormatForPaidAmount(
                                            remaining, selectedCoin),
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme
                                              .colorScheme.onPrimaryContainer,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: identifyPaymentMethodRetail(
                                    selectedValueA: selectedValueA!,
                                    client: widget.client,
                                    invoiceDocumentID: widget.invoiceDocumentID,
                                    paidAmount: amountChanged
                                        ? roundAmount(amountToPay)
                                        : priceToCurrencySelected(
                                            roundAmount(amountToPay),
                                            selectedCoin!),
                                    totalOfTheOrder: getTotalAmount,
                                    date: today,
                                    context: context,
                                    remaining: double.parse(
                                        widget.remaining.toStringAsFixed(4)),
                                    selectedCoin: selectedCoin!,
                                    updatePayed: updatePayed,
                                    paymentBody: AddPaymentBodyAtt(
                                        client: widget.client,
                                        discount: widget.discount,
                                        discountPercentage:
                                            widget.discountPercentage,
                                        invoiceDocumentID:
                                            widget.invoiceDocumentID,
                                        percentageTax: widget.percentageTax,
                                        remaining: widget.remaining,
                                        subTotal: widget.subTotal,
                                        tax: widget.tax,
                                        invoiceNumber: widget.invoiceNumber,
                                        currency: selectedCoin!)
                                      ..payments = widget.payments,
                                  ),
                                )
                              ],
                            )
                          : Container()
                      : Container(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class AddPaymentBodyAtt {
  final double remaining;
  final double subTotal;
  final int discountPercentage;
  final double discount;
  final double tax;
  final int percentageTax;
  final Client client;
  final String invoiceDocumentID;
  final int invoiceNumber;
  final String currency;
  List<PayMethod> payments = [];
  double? amountPaied;

  AddPaymentBodyAtt(
      {required this.remaining,
      required this.subTotal,
      required this.discount,
      required this.discountPercentage,
      required this.tax,
      required this.percentageTax,
      required this.client,
      required this.invoiceDocumentID,
      required this.invoiceNumber,
      required this.currency});
}

class PayMethod {
  String name;
  double amount;

  PayMethod(this.name, this.amount);
}
