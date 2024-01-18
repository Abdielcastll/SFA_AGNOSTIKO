import 'package:flutter/material.dart';

import 'package:agnostiko/agnostiko.dart';

Future<List<CardType>?> showCardReaderDialog(BuildContext context) {
  return showDialog<List<CardType>?>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      List<CardType> _cardTypes = [CardType.IC, CardType.Magnetic, CardType.RF];

      return StatefulBuilder(builder: (context, setState) {
        void _updateCardTypes(bool enabled, CardType type) {
          setState(() {
            if (enabled == true) {
              if (!_cardTypes.contains(type)) {
                _cardTypes = _cardTypes + [type];
              }
            } else {
              _cardTypes = _cardTypes.where((it) => it != type).toList();
            }
          });
        }

        return AlertDialog(
          actionsOverflowButtonSpacing: 1,
          actionsPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          contentPadding: EdgeInsets.only(left: 25, right: 25),
          title: Center(child: Text("cardReader")),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: Container(
            width: 200.0,
            height: 400.0,
            child: ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  CheckboxListTile(
                    title: Text('Magnetic'),
                    value: _cardTypes.contains(CardType.Magnetic),
                    onChanged: (enabled) => _updateCardTypes(
                      enabled ?? false,
                      CardType.Magnetic,
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('IC'),
                    value: _cardTypes.contains(CardType.IC),
                    onChanged: (enabled) => _updateCardTypes(
                      enabled ?? false,
                      CardType.IC,
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('RF'),
                    value: _cardTypes.contains(CardType.RF),
                    onChanged: (enabled) => _updateCardTypes(
                      enabled ?? false,
                      CardType.RF,
                    ),
                  ),
                ],
              ).toList(),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("accept"),
              onPressed: () {
                Navigator.pop(context, _cardTypes);
              },
            ),
            ElevatedButton(
              child: Text("cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
    },
  );
}
