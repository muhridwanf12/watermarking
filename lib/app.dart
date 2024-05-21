import 'package:flutter/material.dart';
import 'package:watermarked/myhomepage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watermarking',
      home: MyHomePage(),
    );
  }
}
