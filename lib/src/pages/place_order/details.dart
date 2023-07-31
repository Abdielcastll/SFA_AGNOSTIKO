// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({
    Key? key,
    this.productName,
    this.productUnits,
    this.productPrice,
    this.productImg,
  }) : super(key: key);

  final productName;
  final productUnits;
  final productPrice;
  final productImg;

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //TODO: utilizar un streambuilder para sacar del carrito;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FadeInImage(
                placeholder: AssetImage('assets/images/loading.gif'),
                image: NetworkImage(
                  widget.productImg,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Edita la cantidad de unidades que quieres en tu producto',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'Unidades:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    color: myTheme.colorScheme.secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 120),
                Container(
                  width: 50,
                  height: 45,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    initialValue: widget.productUnits.toString(),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 2,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      color: myTheme.colorScheme.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (val) =>
                        val!.isEmpty ? 'Entra una cantidad valida' : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  'Producto:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    color: myTheme.colorScheme.secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  width: 200,
                  height: 100,
                  child: Text(
                    '${widget.productName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Container(
                  height: 40,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Confgirmar cambios
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: myTheme.colorScheme.secondary,
                      ),
                      icon: Icon(Feather.check_circle),
                      label: Text(
                        'Confirmar Cambios',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 50),
                Container(
                  height: 40,
                  child: IconButton(
                    onPressed: () {
                      // Eliminar del carrito
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                    icon: Icon(Feather.trash_2),
                    splashRadius: 30,
                    splashColor: Colors.red.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
