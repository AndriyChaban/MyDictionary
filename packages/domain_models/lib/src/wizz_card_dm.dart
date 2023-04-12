import 'package:equatable/equatable.dart';

class WizzCardDM extends Equatable {
  final String word, meaning;
  final String? examples;
  final String? fullText;
  final ShowFrequencyDM? showFrequency;

  const WizzCardDM({
    required this.word,
    required this.meaning,
    this.examples,
    this.fullText,
    this.showFrequency = ShowFrequencyDM.normal,
  });

  @override
  List<Object?> get props => [word, showFrequency, meaning, examples, fullText];
}

enum ShowFrequencyDM { low, normal, high }
