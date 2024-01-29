import 'package:decimal/decimal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/add_new_client/add_new_client_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/identify_payment_method.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<dynamic> showDialogForRegisterPayment(
  BuildContext context,
  String? selectedValueA,
  String formattedDate,
  DateTime today,
  DateFormat dateFormatter,
  String selectedCoin,
  TextEditingController fieldText,
  double moneyRecievedForRegisterMoney,
  double subTotal,
  int discountPercentage,
  double discount,
  int percentageTax,
  double tax,
  double invoiceTotal,
  double change, {
  double? paidAmount,
  double? coinExchangeRatio,
  int? coinDecimals,
  String? coinSymbol,
  double? remaining,
  String? coinName,
  String? coinCode,
  required int paymentsValidPayQuantity,
  required Client client,
  required String invoiceDocumentID,
  required int invoiceNumber,
}) {
  List<String> nationalBanks = [];
  List<String> internationalBanks = [];
  List<String> banks = [];

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      var subTotalConverted = priceMultipliedByItsExchangeRatio2(
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
          productPrice: subTotal);
      var subTotalformatted =
          formatDecimalPriceByRegion(price: subTotalConverted);

      var discountMasterConverted = priceMultipliedByItsExchangeRatio2(
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
          productPrice: discount);
      var discountMasterformatted =
          formatDecimalPriceByRegion(price: discountMasterConverted);

      var taxConverted = priceMultipliedByItsExchangeRatio2(
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
          productPrice: tax);
      var taxformatted = formatDecimalPriceByRegion(price: taxConverted);

      var totalConverted = priceMultipliedByItsExchangeRatio2(
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
          productPrice: invoiceTotal);
      var totalformatted = formatDecimalPriceByRegion(price: totalConverted);

      var balanceConverted = priceMultipliedByItsExchangeRatio2(
          coinDecimals: coinDecimals,
          coinExchangeRatio: coinExchangeRatio,
          productPrice: remaining);
      var balanceformatted =
          formatDecimalPriceByRegion(price: balanceConverted);

      var remainingConverted = priceMultipliedByItsExchangeRatio2(
        productPrice: remaining,
        coinDecimals: coinDecimals,
        coinExchangeRatio: coinExchangeRatio,
      );

      var payedUp = (Decimal.parse(totalConverted.toString()) -
          Decimal.parse(remainingConverted.toString()));

      var payedUpformatted = formatDecimalPriceByRegion(price: payedUp);

      final List<String> items = [
        'Tarjeta de Debito',
        'Tarjeta de Credito',
        'Efectivo',
        'Cheque',
        'Deposito',
        'Transferencia',
        'Transf-internacional',
      ];

      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              // Registrar pagos
              AppLocalizations.of(context)!.registerPayment,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.onPrimaryContainer,
                fontSize: 22,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        // AppLocalizations.of(context)!.paymentMethod,
                        'Tipo de pago',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: myTheme.colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const PointTextWidget(),
                    ],
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              selectedValueA ?? 'Seleccione tipo de pago',
                              style: TextStyle(
                                fontSize: 12,
                                color: myTheme.colorScheme.primary,
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
                        print('selectedValueA: $selectedValueA');
                      },
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Color(0xFFDFE0FF),
                        ),
                        iconSize: 11,
                        iconEnabledColor: Color(0xFFDFE0FF),
                        iconDisabledColor: Colors.grey,
                      ),
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        padding: const EdgeInsets.only(left: 0, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFDFE0FF),
                          ),
                          color: Colors.white,
                        ),
                        elevation: 0,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.date,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: myTheme.colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const PointTextWidget(),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFDFE0FF),
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
                            color: myTheme.colorScheme.primary,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2010),
                                lastDate: DateTime(2030),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      dialogTheme: DialogTheme(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              28), // this is the border radius of the picker
                                        ),
                                      ),
                                      colorScheme: ColorScheme.dark(
                                        primary: myTheme.colorScheme.primary,
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: const Color(0xFF1D1B20),
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: myTheme.colorScheme
                                              .primary, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
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
                              size: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  selectedValueA == null
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                            const SizedBox(width: 3),
                            const PointTextWidget(),
                          ],
                        ),
                  selectedValueA == null
                      ? Container()
                      : Column(
                          children: [
                            Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFDFE0FF),
                                    // color: Colors.transparent,
                                  ),
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        paidAmount = 0;
                                        if (selectedValueA == 'Efectivo') {
                                          change = moneyRecievedForRegisterMoney <
                                                  paidAmount!
                                              ? 0
                                              : double.parse((((Decimal.parse(
                                                                      moneyRecievedForRegisterMoney
                                                                          .toString()) -
                                                                  Decimal.parse(
                                                                      paidAmount!
                                                                          .toString())) *
                                                              Decimal.parse(
                                                                  '100'))
                                                          .round() /
                                                      Decimal.parse('100'))
                                                  // .toDecimal()
                                                  .toDouble()
                                                  .toString());
                                        }
                                      });
                                      print('paidAmount setstate: $paidAmount');
                                    } else {
                                      setState(() {
                                        paidAmount = double.parse(value);
                                        if (selectedValueA == 'Efectivo') {
                                          change = moneyRecievedForRegisterMoney <
                                                  paidAmount!
                                              ? 0
                                              : double.parse((((Decimal.parse(
                                                                      moneyRecievedForRegisterMoney
                                                                          .toString()) -
                                                                  Decimal.parse(
                                                                      paidAmount!
                                                                          .toString())) *
                                                              Decimal.parse(
                                                                  '100'))
                                                          .round() /
                                                      Decimal.parse('100'))
                                                  // .toDecimal()
                                                  .toDouble()
                                                  .toString());
                                        }
                                      });
                                      print('paidAmount setstate: $paidAmount');
                                    }
                                  },
                                  controller: fieldText,
                                  readOnly: selectedValueA == 'Efectivo' ||
                                          selectedValueA == null
                                      ? true
                                      : false,
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
                                        text:
                                            newValue.text.replaceAll(',', '.'),
                                      ),
                                    ),
                                  ],
                                  keyboardType: TextInputType.phone,
                                  maxLines: 1,
                                  maxLength: 50,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    prefixIcon: SizedBox(
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
                                    contentPadding: const EdgeInsets.fromLTRB(
                                      14,
                                      0,
                                      0,
                                      0,
                                    ),
                                    hintText:
                                        // 'PAIDAMOUNT',
                                        '${(formatDecimalPriceByRegion(price: Decimal.parse(paidAmount.toString())))}',
                                    hintStyle: TextStyle(
                                      height: 1.85,
                                      fontFamily: 'Poppins-regular',
                                      fontSize: 14,
                                      color: myTheme.colorScheme.primary,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: selectedValueA != null
                                            ? selectedValueA!
                                                    .contains('Tarjeta')
                                                ? (paidAmount ?? 0) >
                                                        double.parse(
                                                            balanceConverted
                                                                .toString())
                                                    ? Colors.red
                                                    : Colors.transparent
                                                : Colors.transparent
                                            : Colors.transparent,
                                      ),
                                    ),
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                )),
                            selectedValueA != null
                                ? selectedValueA!.contains('Tarjeta')
                                    ? (paidAmount ?? 0) >
                                            balanceConverted.toDouble()
                                        ? const Text(
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
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Recibido ',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: moneyRecievedForRegisterMoney < 0.00001
                                      ? myTheme.colorScheme.primary
                                      : moneyRecievedForRegisterMoney <
                                              paidAmount!
                                          ? Colors.red
                                          : myTheme.colorScheme.primary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const PointTextWidget(),
                            ],
                          ),
                        ),
                  selectedValueA != 'Efectivo'
                      ? Container()
                      : Container(
                          height: 50,
                          // width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: moneyRecievedForRegisterMoney < 0.00001
                                  ? const Color(0xFFDFE0FF)
                                  : moneyRecievedForRegisterMoney < paidAmount!
                                      ? myTheme.colorScheme.error
                                      : const Color(0xFFDFE0FF),
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
                                        : double.parse((((Decimal.parse(
                                                                moneyRecievedForRegisterMoney
                                                                    .toString()) -
                                                            Decimal.parse(
                                                                paidAmount!
                                                                    .toString())) *
                                                        Decimal.parse('100'))
                                                    .round() /
                                                Decimal.parse('100'))
                                            // .toDecimal()
                                            .toDouble()
                                            .toString());
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
                                        : double.parse((((Decimal.parse(
                                                                moneyRecievedForRegisterMoney
                                                                    .toString()) -
                                                            Decimal.parse(
                                                                paidAmount!
                                                                    .toString())) *
                                                        Decimal.parse('100'))
                                                    .round() /
                                                Decimal.parse('100'))
                                            // .toDecimal()
                                            .toDouble()
                                            .toString());
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
                                  : moneyRecievedForRegisterMoney < paidAmount!
                                      ? Colors.red
                                      : myTheme.colorScheme.primary,
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
                              prefixIcon: SizedBox(
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
                              contentPadding: const EdgeInsets.fromLTRB(
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
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                  if (selectedValueA != null)
                    Column(
                      children: [
                        moneyRecievedForRegisterMoney < 0.000001
                            ? Container()
                            : moneyRecievedForRegisterMoney < paidAmount!
                                ? selectedValueA != 'Efectivo'
                                    ? Container()
                                    : Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            15, 5, 15, 0),
                                        child: Text(
                                          'EL MONTO RECIBIDO NO PUEDE SER MENOR QUE EL MONTO TOTAL',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: myTheme.colorScheme.error,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                : Container(),
                        Container(
                          margin: const EdgeInsets.fromLTRB(
                            0,
                            10,
                            0,
                            0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                // 'Subtotal',
                                '$coinSymbol $subTotalformatted',
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
                            0,
                            0,
                            0,
                            0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                // 'Descuento maestro',
                                ' - $coinSymbol $discountMasterformatted',
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
                            0,
                            0,
                            0,
                            0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                // 'Taxes',
                                '$coinSymbol $taxformatted',
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
                            0,
                            0,
                            0,
                            0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                // 'total',
                                '$coinSymbol $totalformatted',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(
                            0,
                            0,
                            0,
                            0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Monto pagado: ',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.primary,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                // 'total',
                                '$coinSymbol $payedUpformatted',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Saldo: ',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                // 'balance',
                                '$coinSymbol $balanceformatted',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selectedValueA == 'Efectivo')
                          Container(
                            alignment: Alignment.bottomCenter,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  // 'Cambio',
                                  '$coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(change.toString()))}',
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
                        const Divider(),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: identifyPaymentMethod(
                            banks: banks,
                            itemsBank: nationalBanks,
                            itemsBankInter: internationalBanks,
                            coinName: coinName,
                            coinDecimals: coinDecimals,
                            coinExchangeRatio: coinExchangeRatio,
                            coinSymbol: coinSymbol,
                            coinCode: coinCode,
                            moneyRecievedForRegisterMoney:
                                moneyRecievedForRegisterMoney,
                            paymentsValidPayQuantity: paymentsValidPayQuantity,
                            selectedValueA: selectedValueA!,
                            client: client,
                            invoiceDocumentID: invoiceDocumentID,
                            paidAmount: paidAmount ?? 0,
                            totalOfTheOrder: invoiceTotal,
                            date: today,
                            context: context,
                            remaining: remaining!,
                            remainingConverted:
                                double.parse(remainingConverted.toString()),
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
                              subTotal: double.parse(subTotal.toString()),
                              currencyExchange: coinExchangeRatio!,
                              tax: tax,
                            ),
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          );
        }),
      );
    },
  );
}
