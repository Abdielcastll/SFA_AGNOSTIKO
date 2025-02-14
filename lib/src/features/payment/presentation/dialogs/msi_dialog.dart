import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pwa_sales2go_flutter/core/constants/msi_constants.dart';
import 'package:pwa_sales2go_flutter/core/font_size.dart';
import 'package:pwa_sales2go_flutter/dialogs/confirm_dialog.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/bin_entitites/bin_response_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/enums/msi_enum.dart';
import 'package:pwa_sales2go_flutter/src/models/transaction_args.dart';

Future<T?> showMSIDialog<T>({
  required BuildContext context,
  required TransactionArgs transProvider,
  required BinResponseEntity binResponse,
}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => _MSIDialog(
            binResponse,
            transProvider,
          ));
}

class _MSIDialog extends StatelessWidget {
  final BinResponseEntity binResponse;
  final TransactionArgs transProvider;
  const _MSIDialog(
    this.binResponse,
    this.transProvider,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dialog.fullscreen(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: _DialogHeader(
                  brand: binResponse.cardBrand.brand,
                  level: binResponse.cardLevel,
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: _DialogBody(
                    msiOptions: binResponse.listMsi,
                    transProvider: transProvider,
                  ),
                ),
              ),
              const Expanded(flex: 1, child: _DialogFooter()),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogFooter extends StatelessWidget {
  const _DialogFooter();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancelar"),
      ),
    );
  }
}

class _DialogBody extends StatelessWidget {
  final List<MSI> msiOptions;
  final TransactionArgs transProvider;
  const _DialogBody({
    required this.msiOptions,
    required this.transProvider,
  });

  @override
  Widget build(BuildContext context) {
    final double totalAmount =
        (transProvider.amountInCents?.toDouble() ?? 0.00) / 100;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: msiOptions.length,
      itemBuilder: (context, index) {
        final int currentMsi = msiOptions[index].msi;
        return _MSIOptionButton(
          msi: currentMsi,
          msiAmount: totalAmount / currentMsi,
          transProvider: transProvider,
        );
      },
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final String? brand;
  final String? level;

  const _DialogHeader({
    this.brand,
    this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            MSIConstants.enjoyCardPromo.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontSize.font2XL,
            ),
          ),
          Text(
            "${brand ?? ''} ${level ?? ''}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: FontSize.font2XL, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class _MSIOptionButton extends StatelessWidget {
  final int msi;
  final double msiAmount;
  final TransactionArgs transProvider;
  const _MSIOptionButton({
    required this.msi,
    required this.msiAmount,
    required this.transProvider,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      shape: MaterialStatePropertyAll<OutlinedBorder?>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      backgroundColor: MaterialStatePropertyAll<Color>(
        Theme.of(context).colorScheme.primary,
      ),
      textStyle: MaterialStatePropertyAll<TextStyle>(
        TextStyle(fontSize: FontSize.font2XL),
      ),
    );

    return FilledButton(
      style: buttonStyle,
      onPressed: () {
        showConfirmDialog(
          context,
          title: MSIConstants.confirmSelection,
          message: MSIConstants.msiSelectedMessage(msi, msiAmount),
          onAccept: () {
            transProvider.msi = MSIConstants.msiFormatter.format(msi);
            // TODO mejorar como se regresa a la pantalla para continuar la transacción
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onCancel: () => Navigator.pop(context),
        );
      },
      child: Text(MSIConstants.msiOptionButtonText(msi, msiAmount)),
    );
  }
}
