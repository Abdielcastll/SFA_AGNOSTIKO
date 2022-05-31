import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    this.iconData,
    this.textEditingController,
    this.hintText,
    this.isObsecure,
    this.enabled,
  }) : super(key: key);

  IconData? iconData;
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10.0),
      child: TextFormField(
        enabled: widget.enabled,
        controller: widget.textEditingController,
        obscureText: widget.isObsecure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Icon(
              widget.iconData,
              color: Theme.of(context).primaryColor,
              size: 25.0,
            ),
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: widget.hintText,
        ),
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        // validator: (email) => email != null && !EmailValidator.validate(email)
        //     ? 'Email invalido'
        //     : null,
      ),
    );
  }
}
