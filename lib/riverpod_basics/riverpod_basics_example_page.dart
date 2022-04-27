import 'package:flutter/material.dart';
import 'package:flutter_equations/flutter_countdown_timer/flutter_countdown_timer_page.dart';
import 'package:flutter_equations/riverpod_basics/future_provider_page.dart';
import 'package:flutter_equations/riverpod_basics/provider_page.dart';
import 'package:flutter_equations/riverpod_basics/state_provider_page.dart';
import 'package:flutter_equations/riverpod_basics/stream_provider_page.dart';
import 'package:flutter_equations/simple_timer/simple_timer_page.dart';

class RiverpodBasicsExamplePage extends StatefulWidget {
  const RiverpodBasicsExamplePage({Key? key}) : super(key: key);

  @override
  State<RiverpodBasicsExamplePage> createState() =>
      _RiverpodBasicsExamplePageState();
}

class _RiverpodBasicsExamplePageState extends State<RiverpodBasicsExamplePage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const FlutterCountdownTimerPage()));
                },
                child: const Text("CountdownTimer")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SimpleTimerPage()));
                },
                child: const Text("SimpleTimer")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProviderPage()));
                },
                child: const Text("Provider")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StateProviderPage()));
                },
                child: const Text("StateProvide")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FutureProviderPage()));
                },
                child: const Text("FutureProvider")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StreamProviderPage()));
                },
                child: const Text("StreamProvider")),
          ],
        ),
      ),
    );
  }
}
