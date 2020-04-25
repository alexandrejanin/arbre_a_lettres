import 'dart:async';

import 'package:arbre_a_lettres/letter.dart';
import 'package:arbre_a_lettres/tree_node.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  Letter _letter;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    Firestore.instance.document('/letters/1').get().then((document) {
      setState(() {
        _letter = Letter.fromDocument(document);
      });
    });

    _subscription?.cancel();
    _subscription = Firestore.instance
        .collection('letters')
        .snapshots()
        .listen((snapshot) async {
      if (_letter != null)
        for (final change in snapshot.documentChanges) {
          _letter.updateTree(change);
        }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_letter == null)
      return Material(
        color: Color(0xFF87CEEB),
      );

    return Material(
      color: Color(0xFF87CEEB),
      child: SingleChildScrollView(
        reverse: true,
        physics: BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: TreeNode(
          key: ValueKey(_letter),
          letter: _letter,
          deletable: false,
        ),
      ),
    );
  }
}
