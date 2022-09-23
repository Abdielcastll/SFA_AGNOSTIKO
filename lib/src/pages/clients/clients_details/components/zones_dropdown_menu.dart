// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ZonesDropDownMenu extends StatefulWidget {
  const ZonesDropDownMenu({
    Key? key,
    required this.zone,
  }) : super(key: key);

  final String zone;

  @override
  State<ZonesDropDownMenu> createState() => _ZonesDropDownMenuState();
}

class _ZonesDropDownMenuState extends State<ZonesDropDownMenu> {
  String? selectedValue;
  final List<String> items = [
    'TERRITORIO1',
    'TERRITORIO2',
    'TERRITORIO3',
    'TERRITORIO4',
    'TERRITORIO5',
    'TERRITORIO6',
    'TERRITORIO7',
    'TERRITORIO8',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    'Zona de Ventas',
                    style: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-regular',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                Row(
                  children: [
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
                                  widget.zone,
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
                            setState(
                              () {
                                selectedValue = value as String;
                              },
                            );
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
                          buttonPadding:
                              const EdgeInsets.only(left: 14, right: 14),
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color:
                                  myTheme.colorScheme.primary.withOpacity(0.3),
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
                          offset: const Offset(-20, 0),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: myTheme.colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Abrir zona para crear nuevos territorios
                          },
                          icon: Icon(Icons.add),
                          color: Colors.grey.shade500,
                          splashRadius: 15,
                          splashColor: myTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
