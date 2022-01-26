import 'dart:developer';

import 'package:flutter/material.dart';

class MyImageApp extends StatelessWidget {
  const MyImageApp({Key? key}) : super(key: key);

  static const int ROW = 1;
  static const int COLOUMN = 2;
  static const int NETOWORK = 3;


  @override
  Widget build(BuildContext context) {
    Widget _child;
    log("###########" + type.toString());
    if (type == ROW) {
      _child = buildRow();
    } else if (type == COLOUMN) {
      _child = buildColumn();
    } else {
      _child = buildNetwork();
    }
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        // Change to buildColumn() for the other column example
        body: Center(child: _child),
      ),
    );
  }

  Widget buildRow() =>
      // #docregion Row
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('images/pic1.jpg'),
          Image.asset('images/pic2.jpg'),
          Image.asset('images/pic3.jpg'),
        ],
      );

  // #enddocregion Row

  Widget buildColumn() =>
      // #docregion Column
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('images/pic1.jpg'),
          Image.asset('images/pic2.jpg'),
          Image.asset('images/pic3.jpg'),
        ],
      );

// #enddocregion Column

  Widget buildNetwork() =>
      // #docregion Column
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('images/pic1.jpg'),
          Image.asset('images/pic2.jpg'),
          Image.asset('images/pic3.jpg'),
        ],
      );
// #enddocregion Column
}
