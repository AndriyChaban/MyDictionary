void printLongString(String? text) {
  if (text == null) {
    print(null);
    return;
  }
  ;
  final pattern = RegExp('.{1,800}', dotAll: true);
  pattern.allMatches(text).forEach((match) {
    print(match.group(0));
  });
}
