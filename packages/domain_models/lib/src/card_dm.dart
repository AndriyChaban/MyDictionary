import 'package:equatable/equatable.dart';

class CardDM extends Equatable {
  final String headword;
  final String text;

  CardDM({
    required this.headword,
    this.text = '',
  });

  @override
  String toString() {
    return 'headword: $headword, text: $text';
  }

  @override
  List<Object> get props => [headword, text];
}
