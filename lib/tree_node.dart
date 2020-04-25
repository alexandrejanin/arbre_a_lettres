import 'package:arbre_a_lettres/button.dart';
import 'package:arbre_a_lettres/letter.dart';
import 'package:arbre_a_lettres/letter_add_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TreeNode extends StatefulWidget {
  final Letter letter;
  final bool showChildren;

  const TreeNode({Key key, @required this.letter, this.showChildren = true})
      : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode> {
  bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showChildren && widget.letter.children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final child in widget.letter.children)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TreeNode(
                      letter: child,
                    ),
                  ),
              ],
            ),
          ),
        GestureDetector(
          onTap: () => setState(() {
            _expanded = !_expanded;
          }),
          child: LetterBox(
            letter: widget.letter,
            expanded: _expanded,
            onTapReply: () async {
              final newLetter = await showDialog(
                context: context,
                builder: (context) => LetterAddPanel(
                  parent: widget.letter,
                ),
              );

              if (newLetter != null)
                setState(() {
                  widget.letter.children.add(newLetter);
                });
            },
          ),
        ),
      ],
    );
  }
}

class LetterBox extends StatelessWidget {
  final Letter letter;
  final bool expanded;
  final void Function() onTapReply;

  const LetterBox({
    Key key,
    @required this.letter,
    @required this.expanded,
    this.onTapReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.ease,
      duration: const Duration(milliseconds: 500),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Color(0xFF23AE26),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                  bottom: Radius.circular(expanded ? 0 : 15),
                ),
              ),
              child: letter.title == null || letter.title.isEmpty
                  ? Icon(
                      Icons.email,
                      color: Colors.white,
                    )
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Text(
                        letter.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            if (expanded) SizedBox(height: 8),
            if (expanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Text(
                    letter.text,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            if (expanded)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      DateFormat('dd/MM/yyyy hh:mm').format(letter.date),
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Button(
                    onTap: onTapReply,
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
          ],
        ),
      ),
    );
  }
}
