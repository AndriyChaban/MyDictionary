extension StringExtension on String {
  String toCapital() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase() + this.substring(1)}";
  }
}
