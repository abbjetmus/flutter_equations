import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<int> fetchWeather() async {
  await Future.delayed(const Duration(seconds: 2));

  return 20;
}

final futureProvider = FutureProvider<int>((ref) async {
  return fetchWeather();
});

class FutureProviderPage extends ConsumerWidget {
  const FutureProviderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final future = ref.watch(futureProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("StateProvider Example")),
      body: Center(
          child: Container(
              child: future.when(
                  data: (value) => Text(value.toString()),
                  error: (e, stack) => Text('Error $e'),
                  loading: () => const CircularProgressIndicator()))),
    );
  }
}
