import 'package:flutter/material.dart';

class CenteredLoadingProgressIndicator extends StatelessWidget {
  const CenteredLoadingProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
