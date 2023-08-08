// ignore_for_file: prefer_const_constructors
import 'dart:math' as math;
import 'package:decimal/decimal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/add_new_client/add_new_client_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_checkout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    required this.invoiceTotal,
    this.amountPayed,
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
  final List<PayMethod> payments;
  final double? amountPayed;
  final double? invoiceTotal;

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  bool _canPop = false;
  @override
  Widget build(BuildContext context) {
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;

    return WillPopScope(
      onWillPop: () async {
        if (_canPop) {
          return true;
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Advertencia"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Salir de este proceso hara que deba continuarlo desde el menu de facturas como registro manual",
                    style: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " ¿Esta seguro que quiere salir?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    final orderActive =
                        Provider.of<OrderProvider>(context, listen: false);

                    setState(() {
                      _canPop = true;
                    });
                    Navigator.popUntil(context, (route) => route.isFirst);
                    objectBox.delelteAllShoppingCart();
                    orderActive.setOrder(false);
                    final j = Provider.of<CounterLimitFirestore>(context,
                        listen: false);
                    j.setNewScreen(1);

                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          backgroundColor:
                              myTheme.colorScheme.onPrimaryContainer,
                          duration: const Duration(seconds: 3),
                          content: Column(
                            children: const [
                              Text(
                                "Facturación Pausada",
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                ),
                              ),
                              Text(
                                "Consulte lista de facturas",
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                  child: Text("Si"),
                ),
              ],
            ),
          );
          return false;
        }
      },
      child: MultiProvider(
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
        child: Scaffold(
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
            invoiceTotal: widget.invoiceTotal,
          ),
        ),
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
    required this.invoiceTotal,
    this.amountPayed,
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
  final List<PayMethod> payments;
  final double? amountPayed;
  final double? invoiceTotal;

  @override
  State<AddPaymentBody> createState() => _AddPaymentBodyState();
}

class _AddPaymentBodyState extends State<AddPaymentBody> {
  late List<PayMethod> payments = widget.payments;
  final TextEditingController fieldTextAmountToPay = TextEditingController();

  get getTotalAmount =>
      double.parse((Decimal.parse(widget.subTotal.toString()) +
              Decimal.parse(widget.tax.toString()) -
              Decimal.parse(widget.discount.toString()))
          .toString());

  bool amountChanged = false;
  double moneyRecievedForRegisterMoney = 0;
  double change = 0;
  double amountPayed = 0;
  var dateFormatter = DateFormat('dd-MM-yyyy');
  DateTime today = DateTime.now();
  String? selectedValueA;
  String? selectedCoin = 'MXN';
  List<String> nationalBanks = [];
  List<String> internationalBanks = [];
  List<String> banks = [];

  updatePayed(double amount) {
    print('payed $amount');
    if (amount != 0) {
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

  @override
  Widget build(BuildContext context) {
    print('OPENING ADD PAYMENT PAGE');
    final coinName = Provider.of<Coin?>(context)?.name ?? '';
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
    final coinCode = Provider.of<Coin?>(context)?.code ?? '';
    print('getTotalAmount: $getTotalAmount');
    print('invoiceDocumentID: ${widget.invoiceDocumentID}');

    // double subTotalConverted = priceMultipliedByItsExchangeRatio(
    //     coinDecimals: coinDecimals,
    //     coinExchangeRatio: coinExchangeRatio,
    //     productPrice: widget.subTotal);
    // print('subtotal: ${widget.subTotal}');
    var subTotalConverted = priceMultipliedByItsExchangeRatio2(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: widget.subTotal);
    print('subTotal: ${widget.subTotal}');
    print('subTotalConverted: $subTotalConverted');

    var subTotalFormatted =
        formatDecimalPriceByRegion(price: subTotalConverted);
    print('subTotalFormatted: $subTotalFormatted');

    var discountMasterConverted = priceMultipliedByItsExchangeRatio2(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: widget.discount);
    print('discountMaster: ${widget.discount}');
    print('discountMasterConverted: $discountMasterConverted');
    var taxConverted = priceMultipliedByItsExchangeRatio2(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: widget.tax);
    print('tax: ${widget.tax}');
    print('taxConverted: $taxConverted');
    var totalConverted = priceMultipliedByItsExchangeRatio2(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: widget.invoiceTotal);
    print('total: ${widget.invoiceTotal}');
    print('totalConverted: $totalConverted');
    var balanceConverted = priceMultipliedByItsExchangeRatio2(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: widget.remaining);
    print('balance: ${widget.remaining}');
    print('balanceConverted: $balanceConverted');
    var remainingConverted = priceMultipliedByItsExchangeRatio2(
      productPrice: widget.remaining,
      coinDecimals: coinDecimals,
      coinExchangeRatio: coinExchangeRatio,
    );
    var paidAmount = priceMultipliedByItsExchangeRatio2(
        productPrice: widget.remaining,
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio);
    print('remaining: ${widget.remaining}');
    print('Remaining converted: $remainingConverted');
    print('PaidAmount inicial: $paidAmount');
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
    print('TEST COINNAME');
    print(coinName);
    double? paymentsTotalAmount = 0;
    for (var payment in widget.payments) {
      paymentsTotalAmount = paymentsTotalAmount! + payment.amount;
    }
    double paymentsTotalAmountConverted = priceMultipliedByItsExchangeRatio(
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
        productPrice: paymentsTotalAmount);
    print('paymentsTotalAmount: $paymentsTotalAmount');
    print('paymentsTotalAmountConverted: $paymentsTotalAmountConverted');

    // final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    String formattedDate = dateFormatter.format(today);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      // child: Container());
      child: paymentForm(
          context,
          items,
          formattedDate,
          double.parse(paidAmount.toString()),
          coinSymbol,
          double.parse(subTotalConverted.toString()),
          double.parse(discountMasterConverted.toString()),
          double.parse(taxConverted.toString()),
          double.parse(totalConverted.toString()),
          paymentsTotalAmount!,
          double.parse(balanceConverted.toString()),
          coinName,
          coinDecimals,
          coinExchangeRatio,
          coinCode,
          double.parse(remainingConverted.toString())),
    );
  }

  Widget paymentForm(
      BuildContext context,
      List<String> items,
      String formattedDate,
      double paidAmount,
      coinSymbol,
      double subTotalConverted,
      double discountMasterConverted,
      double taxConverted,
      double totalConverted,
      double paymentsTotalAmount,
      double balanceConverted,
      coinName,
      coinDecimals,
      coinExchangeRatio,
      coinCode,
      double remainingConverted) {
    return StatefulBuilder(
      builder: (context, setState) => Column(children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Center(
            child: Text(
              'Añadir Pago',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: myTheme.colorScheme.onPrimaryContainer,
                fontFamily: 'Poppins-regular',
              ),
            ),
          ),
        ),
        Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.paymentMethod,
                  style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      color: myTheme.colorScheme.onPrimaryContainer),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedValueA ?? 'Seleccione medio de pago',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                  fontFamily: 'Poppins-regular'),
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
                      onChanged: (value) async {
                        setState(
                          () {
                            selectedValueA = value as String;
                          },
                        );
                        if (value.toString().toLowerCase() == "transferencia" ||
                            value.toString().toLowerCase() == "deposito" ||
                            value.toString().toLowerCase() == "cheque") {
                          print('fetching banks');
                          await banksCollection
                              .where('internacional', isEqualTo: false)
                              .snapshots()
                              .forEach((snapshot) {
                            for (var doc in snapshot.docs) {
                              print('Nacionales');
                              doc.data().toString().contains('nombre')
                                  ? setState(() {
                                      nationalBanks.add(doc.get('nombre'));
                                    })
                                  : null;
                            }
                          }).whenComplete(() => print('done'));
                        } else if (value.toString().toLowerCase() ==
                            "transf-internacional") {
                          print('fetching banks');
                          await banksCollection
                              .where('internacional', isEqualTo: true)
                              .snapshots()
                              .forEach((snapshot) {
                            print('Internacionales');

                            for (var doc in snapshot.docs) {
                              doc.data().toString().contains('nombre')
                                  ? setState(() {
                                      internationalBanks.add(doc.get('nombre'));
                                    })
                                  : null;
                            }
                          }).whenComplete(() => print('done'));
                        }
                        setState(() {});
                        print(selectedValueA);
                      },
                      iconStyleData: IconStyleData(
                        icon: const Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                        iconSize: 11,
                        iconEnabledColor:
                            myTheme.colorScheme.primary.withOpacity(0.5),
                        iconDisabledColor: Colors.grey,
                      ),
                      buttonStyleData: ButtonStyleData(
                        height: 50,

                        // buttonWidth: 200,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: myTheme.colorScheme.primary.withOpacity(0.3),
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
                        maxHeight: 300,
                        width: MediaQuery.of(context).size.width,
                        padding: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        elevation: 8,
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(10),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
                        ),
                        offset: const Offset(0, 0),
                      ),
                    ),
                  ),
                ),
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
                            if (selectedValueA?.contains('Tarjeta') == true ||
                                selectedValueA == null) {
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
                            selectedValueA?.toLowerCase().contains('tarjeta') ==
                                        true ||
                                    selectedValueA == null
                                ? MaterialCommunityIcons.calendar_today
                                : MaterialCommunityIcons.calendar_edit,
                            color: selectedValueA
                                            ?.toLowerCase()
                                            .contains('tarjeta') ==
                                        true ||
                                    selectedValueA == null
                                ? myTheme.colorScheme.secondary
                                : myTheme.colorScheme.primary,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      margin: const EdgeInsets.only(bottom: 5),
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        // priceFormatForPaidAmount(
                                        //     remaining, selectedCoin),
                                        '$coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(balanceConverted.toString()))}',
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
                                      margin: const EdgeInsets.only(bottom: 5),
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        // priceFormat(paymentsTotalAmount),
                                        '$coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(paymentsTotalAmount.toString()))}',
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
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.amount}',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.primary,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 5),
                          PointTextWidget(),
                        ],
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
                            color: myTheme.colorScheme.primary.withOpacity(0.3),
                            // color: Colors.transparent,
                          ),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            // VERIFICAR SI SE VUELVE NULLABLE
                            if (value.isEmpty) {
                              setState(() {
                                paidAmount = 0;
                                if (selectedValueA == 'Efectivo') {
                                  change = moneyRecievedForRegisterMoney <
                                          paidAmount
                                      ? 0
                                      : double.parse((((Decimal.parse(
                                                              moneyRecievedForRegisterMoney
                                                                  .toString()) -
                                                          Decimal.parse(
                                                              paidAmount
                                                                  .toString())) *
                                                      Decimal.parse('100'))
                                                  .round() /
                                              Decimal.parse('100'))
                                          // .toDecimal()
                                          .toDouble()
                                          .toString());
                                  // : double.parse(
                                  //     (moneyRecievedForRegisterMoney -
                                  //             paidAmount)
                                  //         .toStringAsFixed(2),
                                  //   );
                                }
                              });
                              print('paidAmount setstate: $paidAmount');
                            } else {
                              setState(() {
                                paidAmount = double.parse(value);
                                if (selectedValueA == 'Efectivo') {
                                  change = moneyRecievedForRegisterMoney <
                                          paidAmount
                                      ? 0
                                      : double.parse((((Decimal.parse(
                                                              moneyRecievedForRegisterMoney
                                                                  .toString()) -
                                                          Decimal.parse(
                                                              paidAmount
                                                                  .toString())) *
                                                      Decimal.parse('100'))
                                                  .round() /
                                              Decimal.parse('100'))
                                          // .toDecimal()
                                          .toDouble()
                                          .toString());
                                  // : double.parse(
                                  //     (moneyRecievedForRegisterMoney -
                                  //             paidAmount)
                                  //         .toStringAsFixed(2));
                                }
                              });
                              print('paidAmount setstate: $paidAmount');
                            }
                          },
                          readOnly: selectedValueA == 'Efectivo' ? true : false,
                          controller: fieldTextAmountToPay,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins-regular',
                            color: myTheme.colorScheme.primary,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            DecimalTextInputFormatter(decimalRange: 2),
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
                            prefixIcon: Container(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Text(
                                  '$coinSymbol',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 14,
                                    color: myTheme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(
                              14,
                              0,
                              0,
                              0,
                            ),
                            hintText:
                                '${formatDecimalPriceByRegion(price: Decimal.parse(paidAmount.toString()))}',
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
                selectedValueA != 'Efectivo'
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Recibido',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                color: moneyRecievedForRegisterMoney < 0.00001
                                    ? myTheme.colorScheme.primary
                                    : moneyRecievedForRegisterMoney < paidAmount
                                        ? Colors.red
                                        : myTheme.colorScheme.primary,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 5),
                            PointTextWidget(),
                          ],
                        ),
                      ),
                selectedValueA != 'Efectivo'
                    ? Container()
                    : Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: 50,
                        // width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: moneyRecievedForRegisterMoney < 0.00001
                                ? myTheme.colorScheme.primary
                                : moneyRecievedForRegisterMoney < paidAmount
                                    ? Colors.red
                                    : myTheme.colorScheme.primary,
                          ),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                moneyRecievedForRegisterMoney = 0;
                                if (selectedValueA == 'Efectivo') {
                                  change = moneyRecievedForRegisterMoney <
                                          paidAmount
                                      ? 0.00001
                                      : double.parse((((Decimal.parse(
                                                              moneyRecievedForRegisterMoney
                                                                  .toString()) -
                                                          Decimal.parse(
                                                              paidAmount
                                                                  .toString())) *
                                                      Decimal.parse('100'))
                                                  .round() /
                                              Decimal.parse('100'))
                                          // .toDecimal()
                                          .toDouble()
                                          .toString());
                                  // : double.parse(
                                  //     (moneyRecievedForRegisterMoney -
                                  //             paidAmount)
                                  //         .toStringAsFixed(2));
                                }
                              });
                              print(
                                  'moneyRecievedForRegisterMoney: $moneyRecievedForRegisterMoney');
                            } else {
                              setState(() {
                                moneyRecievedForRegisterMoney =
                                    double.parse(value);
                                if (selectedValueA == 'Efectivo') {
                                  change = moneyRecievedForRegisterMoney <
                                          paidAmount
                                      ? 0.00001
                                      : double.parse((((Decimal.parse(
                                                              moneyRecievedForRegisterMoney
                                                                  .toString()) -
                                                          Decimal.parse(
                                                              paidAmount
                                                                  .toString())) *
                                                      Decimal.parse('100'))
                                                  .round() /
                                              Decimal.parse('100'))
                                          // .toDecimal()
                                          .toDouble()
                                          .toString());
                                  // : double.parse(
                                  //     (moneyRecievedForRegisterMoney -
                                  //             paidAmount!)
                                  //         .toStringAsFixed(2));
                                }
                              });
                              print(
                                  'moneyRecievedForRegisterMoney: $moneyRecievedForRegisterMoney');
                            }
                          },
                          // controller:
                          //     fieldText,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins-regular',
                            color: moneyRecievedForRegisterMoney < 0.00001
                                ? myTheme.colorScheme.primary
                                : moneyRecievedForRegisterMoney < paidAmount
                                    ? Colors.red
                                    : myTheme.colorScheme.primary,
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
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Container(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Text(
                                  '$coinSymbol',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 14,
                                    color:
                                        moneyRecievedForRegisterMoney < 0.00001
                                            ? myTheme.colorScheme.primary
                                            : moneyRecievedForRegisterMoney <
                                                    paidAmount
                                                ? Colors.red
                                                : myTheme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(
                              14,
                              0,
                              0,
                              0,
                            ),
                            hintText: 'Ingrese el monto a recibir',
                            // ' ${priceToCurrencySelectedInput(remaining, selectedCoin)}',
                            hintStyle: TextStyle(
                              height: 1.85,
                              fontFamily: 'Poppins-regular',
                              fontSize: 11,
                              color: myTheme.colorScheme.primary,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
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
                              moneyRecievedForRegisterMoney < 0.000001
                                  ? Container()
                                  : moneyRecievedForRegisterMoney < paidAmount
                                      ? selectedValueA != 'Efectivo'
                                          ? Container()
                                          : Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  15, 5, 15, 0),
                                              child: Text(
                                                'EL MONTO RECIBIDO NO PUEDE SER MENOR QUE EL MONTO TOTAL',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color:
                                                      myTheme.colorScheme.error,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                      : Container(),
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
                                      '$coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(subTotalConverted.toString()))}',
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
                                      // double.parse(priceFormatForPaidAmount(
                                      //         widget.discount, selectedCoin))
                                      //     .toStringAsFixed(2),
                                      ' - $coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(discountMasterConverted.toString()))}',
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
                                      '+ $coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(taxConverted.toString()))}',
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
                                      'Total:',
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        color: myTheme.colorScheme.primary,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      '$coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(totalConverted.toString()))}',
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
                                        '$coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(paymentsTotalAmount.toString()))}',
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      // 'Saldo: ${priceFormatForPaidAmount(remaining.toStringAsFixed(4), selectedCoin)}',
                                      // priceFormatForPaidAmount(
                                      //     remaining, selectedCoin),
                                      '$coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(balanceConverted.toString()))}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        color: myTheme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              selectedValueA != 'Efectivo'
                                  ? Container()
                                  : Container(
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
                                          selectedValueA != 'Efectivo'
                                              ? Container()
                                              : Text(
                                                  'Cambio:',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: Colors.green,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                          Text(
                                            '\$ ${formatDecimalPriceByRegion(price: Decimal.parse(change.toString()))}',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              Divider(),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: identifyPaymentMethodRetail(
                                  banks: banks,
                                  itemsBank: nationalBanks,
                                  itemsBankInter: internationalBanks,
                                  coinName: coinName,
                                  coinDecimals: coinDecimals,
                                  coinExchangeRatio: double.parse(
                                      coinExchangeRatio.toString()),
                                  coinSymbol: coinSymbol,
                                  coinCode: coinCode,
                                  moneyRecievedForRegisterMoney:
                                      moneyRecievedForRegisterMoney,
                                  selectedValueA: selectedValueA!,
                                  client: widget.client,
                                  invoiceDocumentID: widget.invoiceDocumentID,
                                  paidAmount: paidAmount,
                                  totalOfTheOrder: getTotalAmount,
                                  date: today,
                                  context: context,
                                  remaining: widget.remaining,
                                  remainingConverted: remainingConverted,
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
                                      currency: selectedCoin!,
                                      currencyExchange: double.parse(
                                          coinExchangeRatio.toString()))
                                    ..payments = widget.payments,
                                ),
                              ),
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
  final double currencyExchange;
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
      required this.currencyExchange,
      required this.currency});
}

class PayMethod {
  String name;
  double amount;

  PayMethod(this.name, this.amount);
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
