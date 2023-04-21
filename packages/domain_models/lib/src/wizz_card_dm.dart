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

  WizzCardDM copyWith({
    String? word,
    String? meaning,
    String? examples,
    String? fullText,
    int? level,
  }) {
    return WizzCardDM(
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      examples: examples ?? this.examples,
      fullText: fullText ?? this.fullText,
      level: level ?? this.level,
    );
  }
}

// enum ShowFrequencyDM { low, normal, high }
