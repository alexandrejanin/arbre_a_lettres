import 'package:arbre_a_lettres/letter.dart';
import 'package:arbre_a_lettres/tree.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF23AE26),
      ),
      home: TreePage(
        letter: Letter(
          date: DateTime.now(),
          title: 'Première lettre',
          text:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          children: [
            Letter(
              date: DateTime.now(),
              title: 'Première réponse',
              text: 'Ceci est la première réponse',
            ),
            Letter(
              date: DateTime.now(),
              text: 'Ceci est la deuxième réponse, et y a pas de titre',
              children: [
                Letter(
                  date: DateTime.now(),
                  title:
                      'Troisième réponse',
                  text: 'Ceci est la troisième réponse',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
