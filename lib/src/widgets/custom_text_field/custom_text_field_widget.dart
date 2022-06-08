import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    // this.iconData,
    this.textEditingController,
    this.hintText,
    this.isObsecure,
    this.enabled,
  }) : super(key: key);

  // IconData? iconData;
  TextEditingController? textEditingController;
  String? hintText;
  bool? isObsecure = true;
  bool? enabled = true;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      // padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0),
      child: TextFormField(
        maxLines: 1,
        textInputAction: TextInputAction.next,
        enabled: widget.enabled,
        style: const TextStyle(fontSize: 14.0),
        controller: widget.textEditingController,
        obscureText: widget.isObsecure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(
              color: Color(0xFF4f42ed),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 191, 191, 191)),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          focusColor: Theme.of(context).primaryColor,
          labelText: widget.hintText,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
