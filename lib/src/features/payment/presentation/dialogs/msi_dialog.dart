import 'dart:async';
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

class _MSIDialog extends StatefulWidget {
  final BinResponseEntity binResponse;
  final TransactionArgs transProvider;

  const _MSIDialog(
    this.binResponse,
    this.transProvider,
  );

  @override
  State<_MSIDialog> createState() => _MSIDialogState();
}

class _MSIDialogState extends State<_MSIDialog> {
  int _timeLeft = 30; // 40 seconds countdown
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 1) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        if (mounted) {
          Navigator.pop(context); // Auto close after 40 seconds
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dialog.fullscreen(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: _DialogHeader(
                      brand: widget.binResponse.cardBrand.brand,
                      level: widget.binResponse.cardLevel,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: _DialogBody(
                        msiOptions: widget.binResponse.listMsi,
                        transProvider: widget.transProvider,
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: _DialogFooter()),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 20,
                child: Text(
                  '$_timeLeft',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18),
                ),
              ),
            ),
          ],
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
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
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

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.7, // Limit width to 70% of screen
        padding: const EdgeInsets.symmetric(vertical: 16), // Add some padding
        child: msiOptions.length == 1
            ? Column(
                mainAxisSize: MainAxisSize.min, // Only takes required space
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                children: [
                  _MSIOptionButton(
                    msi: msiOptions[0].msi,
                    msiAmount: totalAmount / msiOptions[0].msi,
                    transProvider: transProvider,
                    scale: 1.25,
                  ),
                ],
              )
            : Wrap(
                spacing: 18, // Horizontal spacing between buttons
                runSpacing: 18, // Vertical spacing between rows
                alignment: WrapAlignment.center, // Center align buttons
                children: msiOptions.map((msiOption) {
                  return _MSIOptionButton(
                    msi: msiOption.msi,
                    msiAmount: totalAmount / msiOption.msi,
                    transProvider: transProvider,
                  );
                }).toList(),
              ),
      ),
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
          SizedBox(height: 25),
          Text(
            MSIConstants.enjoyCardPromo.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontSize.font2XL,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "${brand ?? ''} ${level ?? ''}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: FontSize.font2XL, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 35),
          Text(
            MSIConstants.chooseMsi,
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
  final double scale;

  const _MSIOptionButton({
    required this.msi,
    required this.msiAmount,
    required this.transProvider,
    this.scale = 1.0, // Default scale is 1.0
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2 * scale, // Scale width
      height: MediaQuery.of(context).size.width * 0.2 * scale, // Scale height
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero, // Remove extra padding
        ),
        onPressed: () {
          showConfirmDialog(
            context,
            title: MSIConstants.confirmSelection,
            message: MSIConstants.msiSelectedMessage(msi, msiAmount),
            onAccept: () {
              transProvider.msi = MSIConstants.msiFormatter.format(msi);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            onCancel: () => Navigator.pop(context),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$msi',
              style: TextStyle(
                fontSize: 20 * scale, // Scale text size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'meses',
              style: TextStyle(
                fontSize: 14 * scale, // Scale text size
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
