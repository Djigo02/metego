import 'package:flutter/material.dart';
import 'package:mete_go/models/config.dart';
import 'package:mete_go/widgets/waiting_message.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WaitingMessage(),
      )
    );
  }
}
