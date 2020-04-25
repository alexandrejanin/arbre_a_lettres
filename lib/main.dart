import 'package:arbre_a_lettres/tree.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feel Good: l\'Arbre à Lettres',
      theme: ThemeData(
        primaryColor: Color(0xFF23AE26),
      ),
      home: TreePage(),
    );
  }
}
