import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TranslationScreenState extends Equatable {
  final SmallBoxParameters? smallBoxParameters;
  final int? currentCardIndex;
  final int? currentWordIndex;
  final bool isLoading;
  final List<DictionaryDM>? listOfDictionariesWithTranslations;

  const TranslationScreenState(
      {this.smallBoxParameters,
      this.listOfDictionariesWithTranslations,
      this.currentCardIndex,
      this.currentWordIndex,
      this.isLoading = false});

  @override
  List<Object?> get props => [
        smallBoxParameters,
        currentCardIndex,
        currentWordIndex,
        isLoading,
        listOfDictionariesWithTranslations
      ];

  TranslationScreenState copyWith({
    SmallBoxParameters? smallBoxParameters,
    int? currentCardIndex,
    int? currentWordIndex,
    bool? isLoading,
    List<DictionaryDM>? listOfDictionariesWithTranslations,
  }) {
    return TranslationScreenState(
      smallBoxParameters: smallBoxParameters ?? this.smallBoxParameters,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      isLoading: isLoading ?? this.isLoading,
      listOfDictionariesWithTranslations: listOfDictionariesWithTranslations ??
          this.listOfDictionariesWithTranslations,
    );
  }
}

class TranslationScreenStateInitial extends TranslationScreenState {
  const TranslationScreenStateInitial() : super();
}

class SmallBoxParameters extends Equatable {
  final String text;
  final String? translation;
  final RenderBox? renderBox;

  const SmallBoxParameters({
    required this.text,
    this.translation,
    this.renderBox,
  });

  @override
  List<Object?> get props => [renderBox, text, translation];
}
