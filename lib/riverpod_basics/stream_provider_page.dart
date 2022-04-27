import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final streamProvider = StreamProvider.autoDispose<String>((ref) {
  return Stream.periodic(
      const Duration(milliseconds: 400), (count) => '$count');
});

class StreamProviderPage extends ConsumerWidget {
  const StreamProviderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("StreamProvider Example")),
      body: Center(child: Container(child: buildStreamWhen(ref))),
    );

    // Widget buildSteramBuilder(watch) {
    //   final stream = watch(streamProvider);

    //   return StreamBuilder<String>(builder: (context, snapshot) => {
    //     switch (snapshot.ConnectionState){
    //       case ConnectionState.waiting:
    //       return CircularProgressIndicator();
    //         break;
    //       default:
    //         if(snapshot.hasErrror) {
    //           return Text('Error: ${snapshot.error}');
    //         } else {
    //           final counter = snapshot.data;
    //           return Text(couter);
    //         }
    //     }
    //   });
    // }
  }

  Widget buildStreamWhen(WidgetRef ref) {
    final stream = ref.watch(streamProvider);
    return stream.when(
        data: (value) => Text(value),
        error: (e, stack) => Text('Error $e'),
        loading: () => const CircularProgressIndicator());
  }
}
