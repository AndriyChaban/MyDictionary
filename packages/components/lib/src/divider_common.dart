import 'package:flutter/material.dart';

class DividerCommon extends StatelessWidget {
  final Color? color;
  const DividerCommon({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1,
      indent: 5,
      endIndent: 5,
      color: color ?? Colors.black12,
    );
  }
}
