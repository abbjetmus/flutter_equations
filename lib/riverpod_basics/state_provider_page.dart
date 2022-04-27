import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stateProvider = StateProvider.autoDispose<int>((ref) => 12);

class StateProviderPage extends ConsumerWidget {
  const StateProviderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(stateProvider.state);
    final counter = provider.state.toString();
    return Scaffold(
      appBar: AppBar(title: const Text("StateProvider Example")),
      body: Center(child: Container(child: Text(counter))),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            provider.state++;
          }),
    );
  }
}
