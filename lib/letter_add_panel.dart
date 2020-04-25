import 'package:arbre_a_lettres/button.dart';
import 'package:arbre_a_lettres/letter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LetterAddPanel extends StatefulWidget {
  final Letter parent;

  const LetterAddPanel({Key key, @required this.parent}) : super(key: key);

  @override
  _LetterAddPanelState createState() => _LetterAddPanelState();
}

class _LetterAddPanelState extends State<LetterAddPanel> {
  TextEditingController _title;
  TextEditingController _text;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _text = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFDBFFDB),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Écrire une réponse',
                style: TextStyle(
                  color: Color(0xFF23AE26),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _title,
                maxLines: 1,
                maxLength: 50,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Titre',
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _text,
                minLines: 2,
                maxLines: 10,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Texte',
                ),
              ),
              SizedBox(height: 16),
              Button(
                onTap: () async {
                  if (_text.text.trim().length <= 0) return;

                  widget.parent.addChild(title: _title.text, text: _text.text);

                  Navigator.pop(context);
                },
                child: Text(
                  'Envoyer',
                  style: TextStyle(
                    color: Color(0xFF23AE26),
                    fontWeight: FontWeight.bold,
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
