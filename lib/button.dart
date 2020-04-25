import 'package:arbre_a_lettres/hand_cursor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget child;
  final void Function() onTap;
  final void Function() onLongPress;

  const Button({Key key, this.child, this.onTap, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HandCursor(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
