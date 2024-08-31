import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OperatorMenuScreen extends ConsumerStatefulWidget {
  const OperatorMenuScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OperatorMenuScreenState();
}

class _OperatorMenuScreenState extends ConsumerState<OperatorMenuScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operator Panel'),
      ),
      body: const Center(
        child: Text('Menu'),
      ),
    );
  }
}