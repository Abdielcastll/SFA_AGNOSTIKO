// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PricesDropDownMenu extends StatefulWidget {
  const PricesDropDownMenu({
    Key? key,
    required this.listOfPrices,
    required this.masterDiscount,
  }) : super(key: key);

  final listOfPrices;
  final masterDiscount;

  @override
  State<PricesDropDownMenu> createState() => _PricesDropDownMenuState();
}

class _PricesDropDownMenuState extends State<PricesDropDownMenu> {
  String? selectedValue;
  final discountController = TextEditingController();
  final List<String> items = [
    'GENER-11',
    'TPGBASE1',
    'TPGBASE2',
    'TPGBASE3',
    'TPGBASE4',
    'TPGBASE5',
    'TPGBASE6',
    'TPGBASE7',
  ];

  @override
  Widget build(BuildContext context) {
    String? selectedDiscount = widget.masterDiscount.toString();
    // print(widget.masterDiscount);
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Text(
                    AppLocalizations.of(context)!.listOfPrices,
                    style: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
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
                              widget.listOfPrices,
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
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                        // Mover la funcion en la base de datos para cambiar la lista
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
                      offset: const Offset(-20, 0),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Text(
                    AppLocalizations.of(context)!.masterDiscount,
                    style: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  height: 50,
                  width: 100,
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
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    maxLength: 3,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: discountController,

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                      hintText: '${widget.masterDiscount}%',
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
                    // onChanged: searchClient,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
