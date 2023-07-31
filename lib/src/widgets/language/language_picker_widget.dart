import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/l10n/l10n.dart';
import 'package:pwa_sales2go_flutter/src/provider/locale_provider.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final flag = L10n.getFlag(locale.languageCode);

    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 72,
        child: Text(
          flag,
          style: TextStyle(fontSize: 65),
        ),
      ),
    );
  }
}

class LanguagePickerWidget extends StatelessWidget {
  const LanguagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.locale;
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        elevation: 2,
        value: locale,
        icon: Container(width: 12),
        items: L10n.all.map(
          (locale) {
            final flag = L10n.getFlag(locale.languageCode);
            return DropdownMenuItem(
              value: locale,
              onTap: () {
                final localeProvider =
                    Provider.of<LocaleProvider>(context, listen: false);
                localeProvider.setLocale(locale);
              },
              child: Center(
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 32),
                ),
              ),
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
