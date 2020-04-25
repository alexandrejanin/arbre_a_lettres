import 'dart:async';

import 'package:arbre_a_lettres/button.dart';
import 'package:arbre_a_lettres/letter.dart';
import 'package:arbre_a_lettres/letter_add_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TreeNode extends StatefulWidget {
  final Letter letter;
  final bool deletable;

  const TreeNode({Key key, @required this.letter, this.deletable = true})
      : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode> {
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.letter.onUpdate.listen(
      (letter) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.letter.children != null && widget.letter.children.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final child in widget.letter.children)
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: widget.letter.children.first == child
                        ? CrossAxisAlignment.end
                        : widget.letter.children.last == child
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TreeNode(
                          key: ValueKey(child),
                          letter: child,
                        ),
                      ),
                      if (widget.letter.children.length > 1)
                        FractionallySizedBox(
                          widthFactor: widget.letter.children.first == child ||
                                  widget.letter.children.last == child
                              ? 0.5
                              : 1.0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.brown,
                                  width: 4,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        if (widget.letter.children != null && widget.letter.children.isNotEmpty)
          Container(
            width: 4,
            height: 20,
            color: Colors.brown,
          ),
        LetterBox(
          letter: widget.letter,
          deletable: widget.deletable,
        ),
        Container(
          width: 4,
          height: 20,
          color: Colors.brown,
        ),
      ],
    );
  }
}

class LetterBox extends StatefulWidget {
  final Letter letter;
  final bool deletable;

  const LetterBox({Key key, @required this.letter, this.deletable=true}) : super(key: key);

  @override
  _LetterBoxState createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> {
  bool _expanded;
  bool _deleteMode;

  @override
  void initState() {
    super.initState();
    _expanded = false;
    _deleteMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
          _deleteMode = false;
        });
      },
      onLongPress: () {
        if (_expanded && widget.deletable)
          setState(() {
            _deleteMode = true;
          });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFDBFFDB),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black26,
            ),
          ],
        ),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_expanded || widget.letter.title.trim().length > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Color(0xFF23AE26),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                      bottom: Radius.circular(_expanded ? 0 : 15),
                    ),
                  ),
                  child:
                      widget.letter.title == null || widget.letter.title.isEmpty
                          ? Icon(
                              Icons.email,
                              color: Colors.white,
                            )
                          : ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 300),
                              child: Text(
                                widget.letter.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                ),
              if (_expanded) SizedBox(height: 8),
              if (_expanded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: Text(
                      widget.letter.text,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              if (_expanded)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        DateFormat('dd/MM/yyyy hh:mm')
                            .format(widget.letter.date),
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Button(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => LetterAddPanel(
                            parent: widget.letter,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Répondre',
                          style: TextStyle(
                            color: Color(0xFF23AE26),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (_deleteMode)
                Button(
                  onTap: () async {
                    final bool result = await showDialog(
                      context: context,
                      builder: (context) => DeleteDialogue(),
                    );
                    if (result != null && result) {
                      widget.letter.delete();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Supprimer',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteDialogue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFDBFFDB),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Voulez-vous vraiment supprimer ce message ?',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Button(
                    onTap: () => Navigator.pop(context, false),
                    child: Text(
                      'Non',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Button(
                    onTap: () => Navigator.pop(context, true),
                    child: Text(
                      'Oui',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
