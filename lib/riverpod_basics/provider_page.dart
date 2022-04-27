import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final numberProvider = Provider<int>((ref) => 42);

class ProviderPage extends StatelessWidget {
  const ProviderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Provider Example")),
        body: Center(
            child: Container(child: Consumer(builder: (context, ref, child) {
          final number = ref.watch(numberProvider).toString();

          return Text(number);
        }))));
  }
}
