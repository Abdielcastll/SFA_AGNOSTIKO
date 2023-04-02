import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/language/language_picker_widget.dart';

class PoweredByAgnostiko extends StatelessWidget {
  const PoweredByAgnostiko({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selector de Idioma
        // const LanguagePickerWidget(),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.center,
          child: Image.asset('assets/images/agnostiko.png'),
        ),
      ],
    );
  }
}
