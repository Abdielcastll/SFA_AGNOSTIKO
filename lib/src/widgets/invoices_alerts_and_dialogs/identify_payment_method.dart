import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

identifyPaymentMethod(
  String? selectedValueA,
) {
  final accountHolder = TextEditingController();
  final accoundNumber = TextEditingController();
  final transactionId = TextEditingController();
  final voucherNumber = TextEditingController();
  final referenceId = TextEditingController();
  String? selectedBank;
  String? selectedCoin;
  List<String> itemsBank = [
    'Banco central',
    'Banco Bicentenario',
    'Banco de venezuela',
    'Banesco',
    'BOD',
    'BNC',
  ];
  List<String> itemsBankInter = [
    'FaceBank',
    'Bank of Panama',
    'Banco de Peru',
    'Bank of Panama',
    'Central bank',
    'Bank of America',
  ];
  List<String> itemsCoin = [
    'USD',
    'BTC',
    'EUR',
    'VED',
  ];
  if (selectedValueA == 'Cheque') {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          Text(
            'Banco *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
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
                        selectedBank ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: itemsBank
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
                value: selectedBank,
                onChanged: (value) {
                  setState(
                    () {
                      selectedBank = value as String;
                    },
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 11,
                iconEnabledColor: myTheme.colorScheme.primary.withOpacity(0.5),
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
                offset: const Offset(-20, 0),
              ),
            ),
          ),
          Text(
            'Nro de Cuenta *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 50,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: accoundNumber,

              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                hintText: '00000000',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14,
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
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
              // onChanged: searchClient,
            ),
          ),
          Text(
            'Titular de la cuenta *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 50,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: accountHolder,

              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                hintText: '',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14,
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
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
              // onChanged: searchClient,
            ),
          ),
          Text(
            'Moneda *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
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
                        selectedCoin ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary.withOpacity(0.7),
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
                iconEnabledColor: myTheme.colorScheme.primary.withOpacity(0.5),
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
                offset: const Offset(-20, 0),
              ),
            ),
          ),
        ],
      ),
    );
  } else if (selectedValueA == 'Criptomoneda') {
    return Column(
      children: [
        Text(
          'Id de la transaccion *',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: myTheme.colorScheme.secondary,
            fontSize: 14,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.primary,
            ),
            keyboardType: TextInputType.phone,
            maxLines: 1,
            maxLength: 50,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            controller: transactionId,

            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              hintText: '00000000',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14,
                color: myTheme.colorScheme.primary.withOpacity(0.2),
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
            // onChanged: searchClient,
          ),
        ),
      ],
    );
  } else if (selectedValueA == 'Deposito') {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          Text(
            'Banco *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
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
                        selectedBank ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: itemsBank
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
                value: selectedBank,
                onChanged: (value) {
                  setState(
                    () {
                      selectedBank = value as String;
                    },
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 11,
                iconEnabledColor: myTheme.colorScheme.primary.withOpacity(0.5),
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
                offset: const Offset(-20, 0),
              ),
            ),
          ),
          Text(
            'Nro de Voucher *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 50,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: voucherNumber,

              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                hintText: '00000000',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14,
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
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
              // onChanged: searchClient,
            ),
          ),
          Text(
            'Nro de Cuenta *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 50,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: accoundNumber,

              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                hintText: '00000000',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14,
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
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
              // onChanged: searchClient,
            ),
          ),
          Text(
            'Moneda *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
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
                        selectedCoin ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary.withOpacity(0.7),
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
                iconEnabledColor: myTheme.colorScheme.primary.withOpacity(0.5),
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
                offset: const Offset(-20, 0),
              ),
            ),
          ),
        ],
      ),
    );
  } else if (selectedValueA == 'Efectivo' ||
      selectedValueA == 'Nota de credito') {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          Text(
            'Moneda *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
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
                        selectedCoin ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary.withOpacity(0.7),
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
                iconEnabledColor: myTheme.colorScheme.primary.withOpacity(0.5),
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
                offset: const Offset(-20, 0),
              ),
            ),
          ),
          selectedValueA == 'Nota de credito'
              ? Container(
                  child: Text(
                    'Disponible en Nota de Credito: \$0.00',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      color: myTheme.colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  } else if (selectedValueA == 'Transferencia' ||
      selectedValueA == 'Transf-internacional') {
    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          Text(
            'Banco *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          selectedValueA == 'Transferencia'
              ? Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      // ignore: prefer_const_literals_to_create_immutables
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedBank ?? '',
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
                      items: itemsBank
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
                      value: selectedBank,
                      onChanged: (value) {
                        setState(
                          () {
                            selectedBank = value as String;
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
                      offset: const Offset(-20, 0),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      // ignore: prefer_const_literals_to_create_immutables
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedBank ?? '',
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
                      items: itemsBankInter
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
                      value: selectedBank,
                      onChanged: (value) {
                        setState(
                          () {
                            selectedBank = value as String;
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
                      offset: const Offset(-20, 0),
                    ),
                  ),
                ),
          Text(
            'Nro de Referencia *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 50,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: referenceId,

              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                hintText: '00000000',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14,
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
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
              // onChanged: searchClient,
            ),
          ),
          Text(
            'Moneda *',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.secondary,
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
                        selectedCoin ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.primary.withOpacity(0.7),
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
                iconEnabledColor: myTheme.colorScheme.primary.withOpacity(0.5),
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
                offset: const Offset(-20, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
