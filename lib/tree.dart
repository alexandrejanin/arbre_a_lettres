import 'package:arbre_a_lettres/letter.dart';
import 'package:arbre_a_lettres/tree_node.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TreePage extends StatelessWidget {
  final Letter letter;

  const TreePage({Key key, @required this.letter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.all(50),
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: TreeNode(
          letter: letter,
        ),
      ),
    );
  }
}
