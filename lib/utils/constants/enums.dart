enum ContactType { familyOrFriend, other }

enum Status {
  unknown,
  initial,
  loading,
  success,
  failure,
  uploading,
  completed
}

enum Game {
  wordSearch,
  solitaire,
  sudoku,
  jigsaw,
}

extension StringExt on String {
  String capitalize() {
    if (isEmpty) {
      return '';
    } else if (length > 1) {
      return "${this[0].toUpperCase()}${substring(1)}";
    }
    return toUpperCase();
  }
}
