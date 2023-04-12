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
      // icon: const Icon(
      //   Icons.question_mark_outlined,
      //   size: 40,
      //   color: Colors.redAccent,
      // ),
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
      actions: [
        TextButton(
            onPressed: onCancel,
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.black54),
            )),
        ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'CONFIRM',
              style: TextStyle(color: Theme.of(context).canvasColor),
            )),
      ],
    );
  }
}
