import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class FlutterCountdownTimerPage extends StatefulWidget {
  const FlutterCountdownTimerPage({Key? key}) : super(key: key);

  @override
  State<FlutterCountdownTimerPage> createState() =>
      FlutterCountdownTimerPageState();
}

class FlutterCountdownTimerPageState extends State<FlutterCountdownTimerPage> {
  late CountdownTimerController controller;

  @override
  void initState() {
    controller = CountdownTimerController(
        endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 30,
        onEnd: endExercise);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CountdownTimer(
          controller: controller,
          widgetBuilder: (_, CurrentRemainingTime? time) {
            if (time == null) {
              return const Text('Game over');
            }
            return Text(
                'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(controller.isRunning ? Icons.stop : Icons.play_arrow),
        onPressed: () {
          if (!controller.isRunning) {
            ///start
            controller.start();
          } else {
            ///pause
          }
          setState(() {
            ///change icon
          });
        },
      ),
    );
  }

  void endExercise() {}
}
