import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class CompleteTrainingDialog extends StatelessWidget {
  final List<WizzCardDM> listOfCards;
  final int numberOfSuccesses;
  final VoidCallback onPressedOk;

  const CompleteTrainingDialog(
      {Key? key,
      required this.listOfCards,
      required this.numberOfSuccesses,
      required this.onPressedOk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        'You have completed training session',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      contentPadding: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.orange, width: 5),
          borderRadius: BorderRadius.circular(15)),
      children: [
        Text(
          'Total number of cards: ${listOfCards.length}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Correct: $numberOfSuccesses',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Wrong: ${listOfCards.length - numberOfSuccesses}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: onPressedOk,
            // style: ElevatedButton.styleFrom(
            //     backgroundColor: Theme.of(context).primaryColor),
            child: const Text(
              'OK',
              // style: TextStyle(color: kPrimaryColor
              // ),
            ),
          ),
        )
      ],
    );
  }
}
