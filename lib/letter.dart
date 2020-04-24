import 'package:flutter/foundation.dart';

class Letter {
  final String title;
  final String text;
  final DateTime date;
  List<Letter> children;

  Letter({
    this.title,
    @required this.text,
    @required this.date,
    this.children,
  }) {
    if (children == null) children = [];
  }
}
