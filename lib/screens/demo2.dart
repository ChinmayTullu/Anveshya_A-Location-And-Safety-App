import 'package:flutter/material.dart';

class Demo2Page extends StatelessWidget {
  const Demo2Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo 2')),
      body: const Center(child: Text('Demo 2 Page')),
    );
  }
}