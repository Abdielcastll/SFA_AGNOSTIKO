// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_checkout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/identify_payment_method.dart';

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage(
      {super.key,
      required this.remaining,
      required this.subTotal,
      required this.discountPercentage,
      required this.discount,
      required this.tax,
      required this.percentageTax,
      required this.invoiceDocumentID,
      required this.client,
      required this.updatePayed});

  final double remaining;
  final double subTotal;
  final int discountPercentage;
  final double discount;
  final double tax;
  final int percentageTax;
  final invoiceDocumentID;
  final client;
  final Function(double) updatePayed;

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
        updatePayed: widget.updatePayed,
      ),
    );
  }
}

class AddPaymentBody extends StatefulWidget {
  const AddPaymentBody({
    super.key,
    required this.remaining,
    required this.subTotal,
    required this.discountPercentage,
    required this.discount,
    required this.tax,
    required this.percentageTax,
    required this.invoiceDocumentID,
    required this.client,
    required this.updatePayed,
  });

  final double remaining;
  final double subTotal;
  final int discountPercentage;
  final double discount;
  final double tax;
  final int percentageTax;
  final invoiceDocumentID;
  final client;
  final Function(double) updatePayed;

  @override
  State<AddPaymentBody> createState() => _AddPaymentBodyState();
}

class _AddPaymentBodyState extends State<AddPaymentBody> {
  late String paidAmount = widget.remaining.toStringAsFixed(2);
  var dateFormatter = DateFormat('dd-MM-yyyy');
  DateTime today = DateTime.now();
  String? selectedValueA;
  String? selectedCoin;
  final List<String> items = [
    'Tarjeta de Debito',
    'Tarjeta de Credito',
    'Cheque',
    'Criptomoneda',
    'Deposito',
    'Efectivo',
    'Transferencia',
    'Transf-internacional',
    // 'Nota de credito',
  ];
  List<String> itemsCoin = [
    'USD',
    'BTC',
    'EUR',
    'VED',
    'MXN',
  ];

  @override
  Widget build(BuildContext context) {
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    String formattedDate = dateFormatter.format(today);

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

    priceFormatForPaidAmount(productPrice, coin) {
      double correctAmount = double.parse(productPrice.toStringAsFixed(2));
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

    return SingleChildScrollView(
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
                              selectedCoin ?? 'Seleccione moneda',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.3),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: itemsCoin
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
                      value: selectedCoin,
                      onChanged: (value) {
                        setState(
                          () {
                            selectedCoin = value as String;
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
                      // buttonWidth: 200,
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
                //  Monto del pago

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
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: myTheme.colorScheme.primary.withOpacity(0.3),
                            // color: Colors.transparent,
                          ),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              paidAmount = value;
                              print(paidAmount);
                            });
                          },
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
                            hintText: priceFormatForPaidAmount(
                                    double.parse(paidAmount.isEmpty
                                        ? '0.00'
                                        : paidAmount),
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
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(
                                  0,
                                  10,
                                  0,
                                  0,
                                ),
                                child: Text(
                                  'Subtotal: ${priceFormatForPaidAmount(widget.subTotal, selectedCoin).toString()} ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color: myTheme.colorScheme.primary,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Text(
                                'Descuento (${widget.discountPercentage}%): ${priceFormatForPaidAmount(widget.discount, selectedCoin).toString()}',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.primary,
                                  fontSize: 10,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'IVA (${widget.percentageTax}%): ${priceFormatForPaidAmount(widget.tax, selectedCoin).toString()}',
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
                                        'Total: ${priceFormatForPaidAmount(widget.remaining, selectedCoin).toString()}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(height: 5),
                              Text(
                                // 'Saldo: ${priceFormatForPaidAmount(remaining.toStringAsFixed(2), selectedCoin)}',
                                'Saldo restante: ${priceFormatForPaidAmount(widget.remaining, selectedCoin)}',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                  fontSize: 10,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: identifyPaymentMethod(
                                  selectedValueA,
                                  widget.client,
                                  widget.invoiceDocumentID,
                                  paidAmount,
                                  // Aqui va widget.InvoiceTotal pero hay
                                  // que consultar si primero se va a
                                  // pagar completo o por partes aca
                                  widget.remaining,
                                  today,
                                  context,
                                  double.parse(
                                      widget.remaining.toStringAsFixed(2)),
                                  selectedCoin,
                                  updatePayed: widget.updatePayed,
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
    );
  }
}
