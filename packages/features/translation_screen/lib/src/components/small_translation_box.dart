import 'package:components/components.dart';
import 'package:flutter/material.dart';

class SmallTranslationBox extends StatelessWidget {
  final String word;
  final String? translation;
  final VoidCallback onClick;

  const SmallTranslationBox(
      {Key? key, required this.word, this.translation, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? textExtract = 'Not translated';
    if (translation != null) {
      textExtract = RegExp(r'<trn>(.+)</trn>')
              .firstMatch(translation!
                  .replaceAll('[', '<')
                  .replaceAll(']', '>')
                  .replaceAll(r'\<', '[')
                  .replaceAll(r'\>', ']'))
              ?.group(1)
              ?.replaceAll(RegExp(r'<.*?>'), '') ??
          translation!.replaceAll(RegExp(r'<.*?>'), '');
    }

    return InkWell(
      onTap: onClick,
      child: Container(
        width: 200,
        // height: 100,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black87,
        ),
        child: Column(
          children: [
            FittedBox(
              child: Text(
                word,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            const DividerCommon(
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                textExtract,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
