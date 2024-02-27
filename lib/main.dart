import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mete_go/screens/home_screen.dart';

void main(){
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "MétéGO",
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
    );
  }
}
