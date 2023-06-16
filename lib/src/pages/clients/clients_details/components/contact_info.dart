import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({
    Key? key,
    required this.tlf1,
    required this.email,
  }) : super(key: key);

  final String tlf1;
  final String email;

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
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.clientContactInfo,
                    style: TextStyle(
                      color: myTheme.colorScheme.primary,
                      fontFamily: 'Poppins-medium',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(20),
                  //   child: Material(
                  //     color: Colors.white,
                  //     child: IconButton(
                  //       onPressed: () {},
                  //       splashColor:
                  //           myTheme.colorScheme.secondary.withOpacity(0.5),
                  //       icon: Icon(
                  //         Feather.edit,
                  //         size: 20,
                  //         color: myTheme.colorScheme.primary,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Text(
                tlf1,
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
                email.toLowerCase(),
                style: const TextStyle(
                  fontFamily: 'Poppins-regular',
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
