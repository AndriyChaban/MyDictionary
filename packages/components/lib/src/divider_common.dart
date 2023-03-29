import 'package:flutter/material.dart';

class DividerCommon extends StatelessWidget {
  const DividerCommon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }
}
