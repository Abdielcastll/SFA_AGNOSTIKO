import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvoiceInfo extends StatelessWidget {
  const InvoiceInfo({
    Key? key,
    required this.tlf2,
    required this.typeId,
    required this.nameId,
  }) : super(key: key);

  final tlf2;
  final typeId;
  final nameId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Text(
                AppLocalizations.of(context)!.clientInvoiceInfo,
                style: TextStyle(
                  color: myTheme.colorScheme.primary,
                  fontFamily: 'Poppins-medium',
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Text(
                tlf2,
                style: const TextStyle(
                  fontFamily: 'Poppins-medium',
                  fontSize: 11,
                  color: Color(0xFF5A5D77),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(10, 5, 0, 10),
              child: Text(
                'RIF: $typeId-$nameId ',
                style: const TextStyle(
                  fontFamily: 'Poppins-medium',
                  fontSize: 11,
                  color: Color(0xFF5A5D77),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
