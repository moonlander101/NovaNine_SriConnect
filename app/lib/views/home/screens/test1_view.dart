import 'package:flutter/material.dart';

class Test1View extends StatelessWidget {
  const Test1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test1'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Test1View!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}