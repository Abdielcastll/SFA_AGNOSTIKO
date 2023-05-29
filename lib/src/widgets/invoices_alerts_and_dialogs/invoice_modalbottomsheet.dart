// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/add_new_client/add_new_client_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/identify_payment_method.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/onTapPayment.dart';

void modalBottomSheetForInvoices(
  bool completed,
  context,
  specialContribuyer,
  masterDiscount,
  fiscalAddress,
  email,
  listOfPrices,
  name,
  tlf1,
  tlf2,
  zone,
  nameId,
  typeId,
  clientDocumentReferenceID,
  invoicePayments,
  int invoiceNumber,
  invoiceTotal,
  client,
  invoiceDocumentID,
  currentClientDispatchAdress,
  subTotal,
  percentageTax,
  double tax,
  discountPercentage,
  discount,
) {
  var dateFormatter = DateFormat('dd-MM-yyyy');
  DateTime today = DateTime.now();
  String formattedDate = dateFormatter.format(today);
  String? selectedValueA;
  String? selectedCoin = 'MXN';

  final paymentsValidPay =
      invoicePayments.where((element) => element['anulado'] == false).toList();
  final int paymentsValidPayQuantity = paymentsValidPay.length;
  final pendingPayments = invoicePayments
      .where((element) =>
          element['anulado'] == false && element['conciliado'] == false)
      .toList();
  final approvedPayments = invoicePayments
      .where((element) =>
          element['anulado'] == false && element['conciliado'] == true)
      .toList();

  print("pendingPayments: $pendingPayments");

  var sumOfPendingPayments = pendingPayments.fold(0, (i, element) {
    return i + element['monto'];
  });

  var sumOfValidPayments = paymentsValidPay.fold(0, (i, element) {
    return i + element['monto'];
  });

  var sumOfApprovedPayments = approvedPayments.fold(0, (i, element) {
    return i + element['monto'];
  });

  print('invoiceTotal: $invoiceTotal');
  print('sumOfValidPayments: $sumOfValidPayments');
  print('sumOfApprovedPayments: $sumOfApprovedPayments');

  double remaining =
      double.parse((invoiceTotal - sumOfValidPayments).toStringAsFixed(4));

  showModalBottomSheet(
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: myTheme.colorScheme.secondary.withOpacity(0.5),
    // isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      print(invoiceDocumentID);
      final currentCoin =
          Provider.of<CurrencyProvider>(context).currentCurrency;

      List<String> currentCoinSplit = currentCoin!.split(' ');
      String currentCoinSelectedCode = currentCoinSplit.last;
      return MultiProvider(
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
        child: StatefulBuilder(
          builder: (context, setState) {
            final coinName = Provider.of<Coin?>(context)?.name ?? '';
            final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
            final coinExchangeRatio =
                Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
            final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
            final coinCode = Provider.of<Coin?>(context)?.code ?? '';
            final fieldText = TextEditingController();
            double paidAmount = priceMultipliedByItsExchangeRatio(
                productPrice: remaining,
                coinDecimals: coinDecimals,
                coinExchangeRatio: coinExchangeRatio);
            print('remaining: $remaining');
            print(
                'Remaining converted: ${priceMultipliedByItsExchangeRatio(productPrice: remaining, coinDecimals: coinDecimals, coinExchangeRatio: coinExchangeRatio)}');
            print('PaidAmount inicial: $paidAmount');

            double moneyRecievedForRegisterMoney = 0;

            double change = 0;

            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          AppLocalizations.of(context)!.options,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: myTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Ver resumen de Cliente
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ClientDetails(
                                          specialContribuyer:
                                              specialContribuyer,
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
                                          clientDocumentReferenceID:
                                              clientDocumentReferenceID,
                                          dispatchAddress:
                                              currentClientDispatchAdress,
                                        ),
                                      ),
                                    );
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
                                  icon: Icon(Icons.person),
                                  label: Text(
                                    AppLocalizations.of(context)!.seeClient,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(width: 15),
                              Container(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // return Container();
                                          return SeePaymentsALertDialog(
                                            dateFormatter: dateFormatter,
                                            invoiceNumber: invoiceNumber,
                                            client: client,
                                            invoiceDocumentID:
                                                invoiceDocumentID,
                                            invoicePayments: invoicePayments,
                                            coinName: coinName,
                                            coinDecimals: coinDecimals,
                                            coinExchangeRatio:
                                                coinExchangeRatio,
                                            coinSymbol: coinSymbol,
                                            coinCode: coinCode,
                                            remaining: remaining,
                                            sumOfApprovedPayments:
                                                sumOfApprovedPayments,
                                            sumOfPendingPayments:
                                                sumOfPendingPayments,
                                            completed: completed,
                                          );
                                        });
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
                                  icon: Icon(Icons.app_registration),
                                  label: Text(
                                    // Ver Pagos
                                    AppLocalizations.of(context)!.seePayments,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Registrar pagos
                          completed
                              ? Container()
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // ignore: use_build_context_synchronously
                                      // /* Navigator.pushNamed(
                                      //   context,
                                      //   AmountInputView.route,
                                      //   arguments: TransactionArgs(
                                      //     platformInfo: platformInfo,
                                      //     entryMode: EntryMode.Magstripe,
                                      //     showNumericKeyboard:
                                      //         !platformInfo.hasKeypad,
                                      //     supportedCardTypes:
                                      //         platformInfo.supportedCardTypes,
                                      //     emvTransactionType:
                                      //         EmvTransactionType.Goods,
                                      //   ),
                                      // ); */
                                      showDialogForRegisterPayment(
                                        context,
                                        selectedValueA,
                                        formattedDate,
                                        today,
                                        dateFormatter,
                                        selectedCoin,
                                        fieldText,
                                        moneyRecievedForRegisterMoney,
                                        subTotal,
                                        discountPercentage,
                                        discount,
                                        percentageTax,
                                        tax,
                                        invoiceTotal,
                                        change,
                                        paidAmount: paidAmount,
                                        coinDecimals: coinDecimals,
                                        coinExchangeRatio: double.parse(
                                            coinExchangeRatio.toString()),
                                        coinSymbol: coinSymbol,
                                        remaining: remaining,
                                        coinName: coinName,
                                        coinCode: coinCode,
                                        paymentsValidPayQuantity:
                                            paymentsValidPayQuantity,
                                        client: client,
                                        invoiceDocumentID: invoiceDocumentID,
                                        invoiceNumber: invoiceNumber,
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
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
                                    icon: Icon(Icons.add_card_outlined),
                                    label: Text(
                                      AppLocalizations.of(context)!
                                          .registerPayment,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

Future<dynamic> showDialogForRegisterPayment(
  BuildContext context,
  String? selectedValueA,
  String formattedDate,
  DateTime today,
  DateFormat dateFormatter,
  String selectedCoin,
  TextEditingController fieldText,
  double moneyRecievedForRegisterMoney,
  subTotal,
  discountPercentage,
  discount,
  percentageTax,
  double tax,
  invoiceTotal,
  double change, {
  double? paidAmount,
  double? coinExchangeRatio,
  int? coinDecimals,
  String? coinSymbol,
  double? remaining,
  String? coinName,
  String? coinCode,
  paymentsValidPayQuantity,
  client,
  invoiceDocumentID,
  invoiceNumber,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      double subTotalConverted = priceMultipliedByItsExchangeRatio(
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
          productPrice: subTotal);
      print('subtotal: $subTotal');
      print('subTotalConverted: $subTotalConverted');
      double discountMasterConverted = priceMultipliedByItsExchangeRatio(
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
          productPrice: discount);
      print('discountMaster: $discount');
      print('discountMasterConverted: $discountMasterConverted');
      double taxConverted = priceMultipliedByItsExchangeRatio(
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
          productPrice: tax);
      print('tax: $tax');
      print('taxConverted: $taxConverted');
      double totalConverted = priceMultipliedByItsExchangeRatio(
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
          productPrice: invoiceTotal);
      print('total: $invoiceTotal');
      print('totalConverted: $totalConverted');
      double balanceConverted = priceMultipliedByItsExchangeRatio(
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
          productPrice: remaining);
      print('balance: $remaining');
      print('balanceConverted: $balanceConverted');
      double remainingConverted = priceMultipliedByItsExchangeRatio(
        productPrice: remaining,
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
      );
      print('remainingConverted: $remainingConverted');
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
        'MXN',
      ];
      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              // Registrar pagos
              AppLocalizations.of(context)!.registerPayment,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.onPrimaryContainer,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.paymentMethod,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            color: myTheme.colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        PointTextWidget(),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          // ignore: prefer_const_literals_to_create_immutables
                          hint: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  selectedValueA ?? 'Seleccione medio de pago',
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
                          value: selectedValueA,
                          onChanged: (value) {
                            setState(
                              () {
                                selectedValueA = value as String;
                              },
                            );
                            print('selectedValueA: $selectedValueA');
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
                            padding: const EdgeInsets.only(left: 0, right: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.3),
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
                            // width: 200,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.date,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            color: myTheme.colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        PointTextWidget(),
                      ],
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
                              color: myTheme.colorScheme.primary,
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: IconButton(
                              onPressed: () async {
                                if (selectedValueA
                                            ?.toLowerCase()
                                            .contains('tarjeta') ==
                                        true ||
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
                                selectedValueA
                                                ?.toLowerCase()
                                                .contains('tarjeta') ==
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
                    selectedCoin == null
                        ? Container()
                        : selectedValueA == null
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Monto a pagar',
                                    // '${AppLocalizations.of(context)!.amount}',
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
                        : selectedValueA == null
                            ? Container()
                            : Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: myTheme.colorScheme.primary
                                              .withOpacity(0.3),
                                          // color: Colors.transparent,
                                        ),
                                      ),
                                      child: TextField(
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            setState(() {
                                              paidAmount = 0;
                                              if (selectedValueA ==
                                                  'Efectivo') {
                                                change = moneyRecievedForRegisterMoney <
                                                        paidAmount!
                                                    ? 0
                                                    : double.parse(
                                                        (moneyRecievedForRegisterMoney -
                                                                paidAmount!)
                                                            .toStringAsFixed(
                                                                2));
                                              }
                                            });
                                            print(
                                                'paidAmount setstate: $paidAmount');
                                          } else {
                                            setState(() {
                                              paidAmount = double.parse(value);
                                              if (selectedValueA ==
                                                  'Efectivo') {
                                                change = moneyRecievedForRegisterMoney <
                                                        paidAmount!
                                                    ? 0
                                                    : double.parse(
                                                        (moneyRecievedForRegisterMoney -
                                                                paidAmount!)
                                                            .toStringAsFixed(
                                                                2));
                                              }
                                            });
                                            print(
                                                'paidAmount setstate: $paidAmount');
                                          }
                                        },
                                        controller: fieldText,
                                        readOnly:
                                            selectedValueA == 'Efectivo' ||
                                                    selectedValueA == null
                                                ? true
                                                : false,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                        ),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]+[,.]{0,1}[0-9]*'),
                                          ),
                                          TextInputFormatter.withFunction(
                                            (oldValue, newValue) =>
                                                newValue.copyWith(
                                              text: newValue.text
                                                  .replaceAll(',', '.'),
                                            ),
                                          ),
                                        ],
                                        keyboardType: TextInputType.phone,
                                        maxLines: 1,
                                        maxLength: 50,
                                        textCapitalization:
                                            TextCapitalization.characters,
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
                                                  color: myTheme
                                                      .colorScheme.primary,
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
                                              '${paidAmount?.toStringAsFixed(2)}',
                                          hintStyle: TextStyle(
                                            height: 1.85,
                                            fontFamily: 'Poppins-regular',
                                            fontSize: 14,
                                            color: myTheme.colorScheme.primary,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                              color: selectedValueA != null
                                                  ? selectedValueA!
                                                          .contains('Tarjeta')
                                                      ? (paidAmount ?? 0) >
                                                              balanceConverted
                                                          ? Colors.red
                                                          : Colors.transparent
                                                      : Colors.transparent
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          counterText: '',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      )),
                                  selectedValueA != null
                                      ? selectedValueA!.contains('Tarjeta')
                                          ? (paidAmount ?? 0) > balanceConverted
                                              ? Text(
                                                  'El pago es mayor al saldo de la factura.',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10),
                                                )
                                              : Container()
                                          : Container()
                                      : Container()
                                ],
                              ),
                    selectedValueA != 'Efectivo'
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Recibido ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    color:
                                        moneyRecievedForRegisterMoney < 0.00001
                                            ? myTheme.colorScheme.primary
                                            : moneyRecievedForRegisterMoney <
                                                    paidAmount!
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
                                    : moneyRecievedForRegisterMoney <
                                            paidAmount!
                                        ? myTheme.colorScheme.error
                                        : myTheme.colorScheme.primary
                                            .withOpacity(0.3),
                                // color: Colors.transparent,
                              ),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    moneyRecievedForRegisterMoney = 0;
                                    if (selectedValueA == 'Efectivo') {
                                      change = moneyRecievedForRegisterMoney <
                                              paidAmount!
                                          ? 0.00001
                                          : double.parse(
                                              (moneyRecievedForRegisterMoney -
                                                      paidAmount!)
                                                  .toStringAsFixed(2));
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
                                              paidAmount!
                                          ? 0.00001
                                          : double.parse(
                                              (moneyRecievedForRegisterMoney -
                                                      paidAmount!)
                                                  .toStringAsFixed(2));
                                    }
                                  });
                                  print(
                                      'moneyRecievedForRegisterMoney: $moneyRecievedForRegisterMoney');
                                }
                              },
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins-regular',
                                color: moneyRecievedForRegisterMoney < 0.00001
                                    ? myTheme.colorScheme.primary
                                    : moneyRecievedForRegisterMoney <
                                            paidAmount!
                                        ? Colors.red
                                        : myTheme.colorScheme.primary,
                              ),
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
                                prefixIcon: Container(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      '$coinSymbol',
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        fontSize: 14,
                                        color: moneyRecievedForRegisterMoney <
                                                0.00001
                                            ? myTheme.colorScheme.primary
                                            : moneyRecievedForRegisterMoney <
                                                    paidAmount!
                                                ? myTheme.colorScheme.error
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
                                hintStyle: TextStyle(
                                  height: 1.85,
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 11,
                                  color: moneyRecievedForRegisterMoney < 0.00001
                                      ? myTheme.colorScheme.primary
                                      : moneyRecievedForRegisterMoney <
                                              paidAmount!
                                          ? myTheme.colorScheme.error
                                          : myTheme.colorScheme.primary,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
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
                                  moneyRecievedForRegisterMoney < 0.000001
                                      ? Container()
                                      : moneyRecievedForRegisterMoney <
                                              paidAmount!
                                          ? selectedValueA != 'Efectivo'
                                              ? Container()
                                              : Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      15, 5, 15, 0),
                                                  child: Text(
                                                    'EL MONTO RECIBIDO NO PUEDE SER MENOR QUE EL MONTO TOTAL',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      color: myTheme
                                                          .colorScheme.error,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                          : Container(),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                      15,
                                      10,
                                      15,
                                      0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Subtotal: ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: myTheme.colorScheme.primary,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          '$coinSymbol ${subTotalConverted.toStringAsFixed(2)}',
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
                                      15,
                                      0,
                                      15,
                                      0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Descuento Maestro ($discountPercentage%): ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: myTheme.colorScheme.primary,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          ' - $coinSymbol ${discountMasterConverted.toStringAsFixed(2)}',
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
                                      15,
                                      0,
                                      15,
                                      0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'IVA (16%): ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: myTheme.colorScheme.primary,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          '$coinSymbol ${taxConverted.toStringAsFixed(2)}',
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
                                      15,
                                      0,
                                      15,
                                      0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total: ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: myTheme.colorScheme.primary,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          '$coinSymbol ${totalConverted.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: myTheme
                                                .colorScheme.onPrimaryContainer,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Saldo: ',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: myTheme
                                                .colorScheme.onPrimaryContainer,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '$coinSymbol ${balanceConverted.toStringAsFixed(2)}',
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
                                          alignment: Alignment.bottomCenter,
                                          margin:
                                              EdgeInsets.fromLTRB(15, 0, 15, 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            // selectedValueA != 'Efectivo'
                                            //     ? MainAxisAlignment.center
                                            //     : MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                'Cambio: ',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.green.shade600,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '$coinSymbol ${change.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.green.shade600,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  Divider(),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      0,
                                      5,
                                      0,
                                      0,
                                    ),
                                    child: identifyPaymentMethod(
                                      coinName: coinName,
                                      coinDecimals: coinDecimals,
                                      coinExchangeRatio: coinExchangeRatio,
                                      coinSymbol: coinSymbol,
                                      coinCode: coinCode,
                                      moneyRecievedForRegisterMoney:
                                          moneyRecievedForRegisterMoney,
                                      paymentsValidPayQuantity:
                                          paymentsValidPayQuantity,
                                      selectedValueA: selectedValueA!,
                                      client: client,
                                      invoiceDocumentID: invoiceDocumentID,
                                      paidAmount: paidAmount ?? 0,
                                      totalOfTheOrder: invoiceTotal,
                                      date: today,
                                      context: context,
                                      remaining: remaining!,
                                      remainingConverted: remainingConverted,
                                      selectedCoin: selectedCoin,
                                      noRetail: true,
                                      paymentBody: AddPaymentBodyAtt(
                                          client: client,
                                          currency: selectedCoin,
                                          discount: 0,
                                          discountPercentage: 0,
                                          invoiceDocumentID: invoiceDocumentID,
                                          invoiceNumber: invoiceNumber,
                                          percentageTax: percentageTax,
                                          remaining: remaining,
                                          subTotal: subTotal,
                                          currencyExchange: coinExchangeRatio!,
                                          tax: tax),
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
          );
        }),
      );
    },
  );
}

class SeePaymentsALertDialog extends StatelessWidget {
  SeePaymentsALertDialog({
    super.key,
    required this.dateFormatter,
    required this.invoiceNumber,
    required this.client,
    required this.invoiceDocumentID,
    required this.invoicePayments,
    required this.coinName,
    required this.coinDecimals,
    required this.coinExchangeRatio,
    required this.coinSymbol,
    required this.coinCode,
    required this.remaining,
    required this.sumOfApprovedPayments,
    required this.sumOfPendingPayments,
    required this.completed,
  });

  var invoicePayments;
  final DateFormat dateFormatter;
  final int invoiceNumber;
  final client;
  final invoiceDocumentID;
  final coinName;
  final coinDecimals;
  final coinExchangeRatio;
  final coinSymbol;
  final coinCode;
  final remaining;
  final sumOfApprovedPayments;
  final sumOfPendingPayments;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StatefulBuilder(builder: ((context, setState) {
        double remainingConverted = priceMultipliedByItsExchangeRatio(
          productPrice: remaining,
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
        );
        print('remainingConverted: $remainingConverted');

        double sumOfApprovedPaymentsConverted =
            priceMultipliedByItsExchangeRatio(
          productPrice: sumOfApprovedPayments,
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
        );
        print(
            'sumOfApprovedPaymentsConverted: $sumOfApprovedPaymentsConverted');

        double sumOfPendingPaymenstConverted =
            priceMultipliedByItsExchangeRatio(
          productPrice: sumOfPendingPayments,
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
        );
        print('sumOfPendingPaymenstConverted: $sumOfPendingPaymenstConverted');

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            '${AppLocalizations.of(context)!.invoiceNumber} #$invoiceNumber',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.onPrimaryContainer,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    // color: Colors.grey,
                    height: 330,
                    width: MediaQuery.of(context).size.width,
                    child: invoicePayments.isEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          // Colors.red.withOpacity(0.3)),
                                          myTheme.colorScheme.primary
                                              .withOpacity(0.3)),
                                  width: 110,
                                  height: 110,
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Icon(
                                      MaterialCommunityIcons.archive_alert,
                                      color: myTheme
                                          .colorScheme.onPrimaryContainer,
                                      size: 60,
                                    ),
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.noPayments,
                                  style: TextStyle(
                                    fontFamily: 'Poppins-regular',
                                    fontSize: 13,
                                    color:
                                        myTheme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ],
                            ))
                        : Scrollbar(
                            thumbVisibility: true,
                            child: ListView.builder(
                              itemCount: invoicePayments.length,
                              itemBuilder: (context, index) {
                                final isLast =
                                    index == (invoicePayments.length - 1);
                                final payment = invoicePayments[index];
                                final date = payment['fecha'];
                                final unformattedDate =
                                    DateTime.parse(date.toDate().toString());
                                final paymentDate =
                                    dateFormatter.format(unformattedDate);

                                final double paymentAmount =
                                    priceMultipliedByItsExchangeRatio(
                                  productPrice: payment['monto'],
                                  coinDecimals: coinDecimals,
                                  coinExchangeRatio: payment['tasaDeCambio'],
                                );

                                final fecha =
                                    (payment['fecha'] as Timestamp).toDate();
                                final hoy = DateTime.now();
                                var permitirCancelacion = false;

                                if (fecha.year == hoy.year &&
                                    fecha.month == hoy.month &&
                                    fecha.day == hoy.day &&
                                    fecha.hour < 22) {
                                  permitirCancelacion = true;
                                }

                                final mostrarCancelacionDevolucion =
                                    payment['metodo']
                                            .toString()
                                            .toLowerCase()
                                            .contains('tarjeta') &&
                                        payment['stan'] != null;

                                final yaAnuladoConciliadoRefund =
                                    payment['anulado'] == true ||
                                        payment['conciliado'] == true ||
                                        payment['refund'] == true;

                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () async {},
                                      leading: Icon(
                                        Icons.money_off_csred,
                                        color: payment['refund'] == true
                                            ? Colors.blue.shade800
                                            : payment['anulado'] == false
                                                ? payment['conciliado'] == false
                                                    ? Colors.amber.shade600
                                                    : Colors.green.shade600
                                                : myTheme.colorScheme.error,
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$coinSymbol ${paymentAmount.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              color: payment['refund'] == true
                                                  ? Colors.blue.shade800
                                                  : payment['anulado'] == false
                                                      ? payment['conciliado'] ==
                                                              false
                                                          ? Colors
                                                              .amber.shade600
                                                          : Colors
                                                              .green.shade600
                                                      : myTheme
                                                          .colorScheme.error,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              paymentDate,
                                              style: TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                color: myTheme
                                                    .colorScheme.secondary,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        '${payment['metodo']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.secondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    if (mostrarCancelacionDevolucion &&
                                        !yaAnuladoConciliadoRefund)
                                      Column(
                                        children: [
                                          if (permitirCancelacion)
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                final newPayments =
                                                    await cancel(
                                                        context,
                                                        payment,
                                                        AppLocalizations.of(
                                                                context)!
                                                            .pleaseWait,
                                                        client,
                                                        invoiceDocumentID,
                                                        index);
                                                if (newPayments == null) {
                                                  return;
                                                }
                                                setState(
                                                  () => invoicePayments =
                                                      newPayments,
                                                );
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateColor
                                                          .resolveWith(
                                                (states) => Colors.red,
                                              )),
                                              icon: Icon(
                                                Icons.block_rounded,
                                                size: 16,
                                              ),
                                              label: Text('Cancelación',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                            ),
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              refund(
                                                  context,
                                                  payment,
                                                  AppLocalizations.of(context)!
                                                      .pleaseWait,
                                                  client,
                                                  invoiceDocumentID,
                                                  index);
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith(
                                              (states) => Colors.green,
                                            )),
                                            icon: Icon(
                                              Icons.currency_exchange_rounded,
                                              size: 16,
                                            ),
                                            label: Text('Devolución',
                                                style: TextStyle(fontSize: 12)),
                                          )
                                        ],
                                      ),
                                    if (!isLast)
                                      Divider(
                                        endIndent: 8,
                                        indent: 8,
                                      )
                                  ],
                                );
                              },
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.upToPay}: ',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      completed
                          ? '$coinSymbol 0.00'
                          : '$coinSymbol ${remainingConverted.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                remainingConverted <= 0
                    ? SizedBox(
                        height: 5,
                      )
                    : Container(),
                remainingConverted <= 0
                    ? Text(
                        'Esta factura no tiene deuda',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: myTheme.colorScheme.error,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
                remainingConverted <= 0
                    ? SizedBox(
                        height: 5,
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.balanceConfirmed}: ',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.green.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$coinSymbol ${sumOfApprovedPaymentsConverted.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.green.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.balanceLeft}: ',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.amber.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // '${AppLocalizations.of(context)!.balanceLeft}: ${priceFormat(sumOfPendingPayments)}',
                      '$coinSymbol ${sumOfPendingPaymenstConverted.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: Colors.amber.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.goBack,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      })),
    );
  }
}

// class DecimalTextInputFormatter extends TextInputFormatter {
//   DecimalTextInputFormatter({required this.decimalRange})
//       : assert(decimalRange == null || decimalRange > 0);

//   final int decimalRange;

//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue, // unused.
//     TextEditingValue newValue,
//   ) {
//     TextSelection newSelection = newValue.selection;
//     String truncated = newValue.text;

//     if (decimalRange != null) {
//       String value = newValue.text;

//       if (value.contains(".") &&
//           value.substring(value.indexOf(".") + 1).length > decimalRange) {
//         truncated = oldValue.text;
//         newSelection = oldValue.selection;
//       } else if (value == ".") {
//         truncated = "0.";

//         newSelection = newValue.selection.copyWith(
//           baseOffset: math.min(truncated.length, truncated.length + 1),
//           extentOffset: math.min(truncated.length, truncated.length + 1),
//         );
//       }

//       return TextEditingValue(
//         text: truncated,
//         selection: newSelection,
//         composing: TextRange.empty,
//       );
//     }
//     return newValue;
//   }
// }
