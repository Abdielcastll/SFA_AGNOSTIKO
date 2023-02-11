import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressInfo extends StatelessWidget {
  const AddressInfo({
    Key? key,
    required this.fiscalAddress,
  }) : super(key: key);

  final String fiscalAddress;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                AppLocalizations.of(context)!.clientFiscalAddress,
                style: TextStyle(
                  color: myTheme.colorScheme.primary,
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(10, 5, 0, 10),
              child: Text(
                fiscalAddress.toLowerCase(),
                style: const TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
