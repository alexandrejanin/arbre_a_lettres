import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Letter {
  final String id;
  String title;
  String text;
  DateTime date;
  List<Letter> children;

  final StreamController<Letter> _onUpdate;

  Stream<Letter> get onUpdate => _onUpdate.stream;

  Letter.fromDocument(DocumentSnapshot document)
      : id = document.documentID,
        title = document['title'],
        text = document['text'],
        date = (document['date'] as Timestamp).toDate(),
        _onUpdate = StreamController.broadcast() {
    Firestore.instance
        .collection('letters')
        .where('parent', isEqualTo: Firestore.instance.document('/letters/$id'))
        .getDocuments()
        .then((snapshot) {
      children =
          snapshot.documents.map((doc) => Letter.fromDocument(doc)).toList();

      _onUpdate.add(this);
    });
  }

  void addChild({@required String title, @required String text}) {
    Firestore.instance.collection('letters').add({
      'title': title,
      'text': text,
      'date': DateTime.now(),
      'parent': Firestore.instance.document('/letters/$id'),
    });
  }

  void delete() {
    Firestore.instance.document('/letters/$id').delete();
    for (final child in children) {
      child.delete();
    }
  }

  void updateTree(DocumentChange change) {
    switch (change.type) {
      case DocumentChangeType.added:
        final DocumentReference parent = change.document['parent'];
        if (parent != null && id == parent.documentID) {
          children.add(Letter.fromDocument(change.document));
          _onUpdate.add(this);
        } else
          for (final child in children) {
            child.updateTree(change);
          }
        break;
      case DocumentChangeType.modified:
        if (id == change.document.documentID) {
          title = change.document['title'];
          text = change.document['text'];
          date = (change.document['date'] as Timestamp).toDate();
          _onUpdate.add(this);
        } else
          for (final child in children) {
            child.updateTree(change);
          }
        break;
      case DocumentChangeType.removed:
        final previousLength = children.length;
        children.removeWhere((child) => child.id == change.document.documentID);
        if (children.length != previousLength)
          _onUpdate.add(this);
        else
          for (final child in children) {
            child.updateTree(change);
          }
        break;
    }
  }
}
