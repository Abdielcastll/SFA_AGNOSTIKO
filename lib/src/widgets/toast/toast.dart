import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

customToast({
  required FToast fToast,
  required String msg,
  required Color backgroundColor,
  required Icon icon,
  required Color textColor,
}) {
  return fToast.showToast(
    gravity: ToastGravity.BOTTOM,
    // toastDuration: const Duration(seconds: 3),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: backgroundColor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: textColor.withOpacity(0.1),
                child: icon,
              ),
              const SizedBox(width: 16),
              Text(
                msg,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  letterSpacing: 0.5,
                  fontFamily: 'Poppins-Medium',
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
