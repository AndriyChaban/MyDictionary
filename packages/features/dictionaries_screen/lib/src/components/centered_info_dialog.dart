import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CenteredInfoDialog extends StatelessWidget {
  final String message;
  const CenteredInfoDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: SimpleDialog(
          alignment: Alignment.center,
          title: const Text(
            'Adding dictionary',
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.all(15),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(message),
                const SizedBox(height: 15),
                // const SizedBox(
                //   height: 30,
                //   width: 30,
                //   child: CircularProgressIndicator(),
                // ),
                Lottie.asset('assets/icons/105407-rocketship-smoke-trail.json',
                    width: 100, height: 100),
                const SizedBox(height: 5),
              ],
            )
          ],
        ),
      ),
    );
  }
}
