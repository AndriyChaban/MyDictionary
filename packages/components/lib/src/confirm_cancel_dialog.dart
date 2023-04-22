import 'package:flutter/material.dart';

class ConfirmCancelDialog extends StatelessWidget {
  const ConfirmCancelDialog(
      {Key? key,
      required this.title,
      this.message,
      required this.onCancel,
      required this.onConfirm})
      : super(key: key);

  final String? message;
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Text(
        title,
        softWrap: true,
        textAlign: TextAlign.center,
      ),
      alignment: Alignment.center,
      content: message != null
          ? Text(
              message!,
              softWrap: true,
              // textAlign: TextAlign.center,
            )
          : null,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      actions: [
        TextButton(
            onPressed: onCancel,
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.black54),
            )),
        ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            child: Text(
              'CONFIRM',
              style: TextStyle(color: Theme.of(context).canvasColor),
            )),
      ],
    );
  }
}
