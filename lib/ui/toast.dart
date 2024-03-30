import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(FToast fToast, String message) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
    ),
    child: Text(message),
  );

  fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3));
}
