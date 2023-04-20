import 'package:equatable/equatable.dart';

class WizzCardDM extends Equatable {
  final String word, meaning;
  final String? examples;
  final String? fullText;
  final int level;
  // final ShowFrequencyDM? showFrequency;

  const WizzCardDM({
    this.level = 1,
    required this.word,
    required this.meaning,
    this.examples,
    this.fullText,
    // this.showFrequency = ShowFrequencyDM.normal,
  });

  @override
  List<Object?> get props => [word, level, meaning, examples, fullText];
}

// enum ShowFrequencyDM { low, normal, high }
