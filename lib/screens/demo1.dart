import 'package:flutter/material.dart';

class Demo1Page extends StatelessWidget {
  const Demo1Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo 1')),
      body: const Center(child: Text('Demo 1 Page')),
    );
  }
}