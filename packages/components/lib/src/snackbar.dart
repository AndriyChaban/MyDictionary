import 'package:flutter/material.dart';

void buildInfoSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    // width: MediaQuery.of(context).size.width / 2,
    behavior: SnackBarBehavior.floating,
    // shape: const StadiumBorder(),
    backgroundColor: Colors.black54,
    content: Text(
      message,
      textAlign: TextAlign.center,
      softWrap: true,
    ),
    duration: const Duration(seconds: 2),
  ));
}

void hideSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}
