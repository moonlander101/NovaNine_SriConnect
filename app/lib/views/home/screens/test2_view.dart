import 'package:flutter/material.dart';

class Test2View extends StatelessWidget {
  const Test2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test2'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Test2View!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}