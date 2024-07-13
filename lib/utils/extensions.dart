extension StringExtension on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    return split(' ')
        .map((element) =>
    "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .join(" ");
  }
}
