import 'package:flutter/material.dart';
import 'package:flutter_test_saas_mlkit/home_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Flutter Test Liveness",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        motionCount: 3,
      ),
    );
  }
}