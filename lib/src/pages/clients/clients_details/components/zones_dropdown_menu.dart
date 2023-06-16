import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        margin: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    AppLocalizations.of(context)!.salesArea,
                    style: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-medium',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      height: 50,
                      width: 280,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: myTheme.colorScheme.primary.withOpacity(0.7),
                          )),
                      child: Text(
                        widget.zone,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins-medium',
                          fontSize: 14,
                          color: Color.fromARGB(255, 40, 41, 48),
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
