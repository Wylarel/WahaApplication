import 'package:flutter/material.dart';

class Load extends StatefulWidget {
  final double size;

  Load(this.size);

  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}