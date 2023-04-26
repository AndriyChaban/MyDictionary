import 'package:flutter/material.dart';

void buildInfoSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    // width: MediaQuery.of(context).size.width / 2,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    backgroundColor: Colors.black54,
    content: Text(
      message,
      textAlign: TextAlign.center,
      softWrap: true,
      style:
          TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
    ),
    duration: const Duration(seconds: 2),
  ));
}

void hideSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}
