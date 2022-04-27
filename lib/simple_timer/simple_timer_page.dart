import 'package:flutter/material.dart';
import 'package:simple_timer/simple_timer.dart';

class SimpleTimerPage extends StatefulWidget {
  const SimpleTimerPage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SimpleTimerPage>
    with SingleTickerProviderStateMixin {
  late TimerController _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;

  @override
  void initState() {
    // initialize timercontroller
    _timerController = TimerController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Simple Timer",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: SimpleTimer(
              duration: const Duration(seconds: 5),
              controller: _timerController,
              timerStyle: _timerStyle,
              onStart: handleTimerOnStart,
              onEnd: handleTimerOnEnd,
              valueListener: timerValueChangeListener,
              backgroundColor: Colors.grey,
              progressIndicatorColor: Colors.green,
              progressIndicatorDirection: _progressIndicatorDirection,
              progressTextCountDirection: _progressTextCountDirection,
              progressTextStyle: const TextStyle(color: Colors.black),
              strokeWidth: 10,
            ),
          )),
          Column(
            children: <Widget>[
              const Text(
                "Timer Status",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                      onPressed: _timerController.start,
                      child: const Text("Start",
                          style: TextStyle(color: Colors.white)),
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.green)),
                  TextButton(
                      onPressed: _timerController.pause,
                      child: const Text("Pause",
                          style: TextStyle(color: Colors.white)),
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.blue)),
                  TextButton(
                      onPressed: _timerController.reset,
                      child: const Text("Reset",
                          style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(backgroundColor: Colors.red)),
                  TextButton(
                      onPressed: _timerController.restart,
                      child: const Text("Restart",
                          style: TextStyle(color: Colors.white)),
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.orange)),
                ],
              )
            ],
          ),
          Column(
            children: <Widget>[
              const Text(
                "Timer Style",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                      child: TextButton(
                          onPressed: () => _setStyle(TimerStyle.ring),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text("Ring",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)))),
                  Flexible(
                    child: TextButton(
                        onPressed: () => _setStyle(TimerStyle.expanding_circle),
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text("Expanding Circle",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white))),
                  ),
                  Flexible(
                    child: TextButton(
                        onPressed: () => _setStyle(TimerStyle.expanding_sector),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.orange),
                        child: const Text("Expanding Sector",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white))),
                  ),
                  Flexible(
                    child: TextButton(
                        onPressed: () =>
                            _setStyle(TimerStyle.expanding_segment),
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Expanding Segment",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white))),
                  )
                ],
              )
            ],
          ),
          Column(
            children: <Widget>[
              const Text(
                "Timer Count Direction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(
                    onPressed: () => _setCountDirection(
                        TimerProgressTextCountDirection.count_up),
                    style: TextButton.styleFrom(backgroundColor: Colors.blue),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Flexible(
                            child: Text("Count Up",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white))),
                        Flexible(
                            child: Icon(Icons.arrow_upward,
                                size: 18, color: Colors.white)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _setCountDirection(
                        TimerProgressTextCountDirection.count_down),
                    style: TextButton.styleFrom(backgroundColor: Colors.orange),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Flexible(
                            child: Text("Count Down",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white))),
                        Icon(Icons.arrow_downward,
                            size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Column(
            children: <Widget>[
              const Text(
                "Timer Progress Indicator Direction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(
                    onPressed: () => _setProgressIndicatorDirection(
                        TimerProgressIndicatorDirection.clockwise),
                    style: TextButton.styleFrom(backgroundColor: Colors.blue),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Flexible(
                            child: Text("Clockwise",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white))),
                        Flexible(
                            child: Icon(Icons.subdirectory_arrow_left,
                                size: 18, color: Colors.white)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _setProgressIndicatorDirection(
                        TimerProgressIndicatorDirection.both),
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Flexible(
                            child: Text("Both",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white))),
                        Icon(Icons.compare_arrows,
                            size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _setProgressIndicatorDirection(
                        TimerProgressIndicatorDirection.counter_clockwise),
                    style: TextButton.styleFrom(backgroundColor: Colors.orange),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Flexible(
                            child: Text("Counter Clockwise",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white))),
                        Icon(Icons.subdirectory_arrow_right,
                            size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      )),
    );
  }

  void _setCountDirection(TimerProgressTextCountDirection countDirection) {
    setState(() {
      _progressTextCountDirection = countDirection;
    });
  }

  void _setProgressIndicatorDirection(
      TimerProgressIndicatorDirection progressIndicatorDirection) {
    setState(() {
      _progressIndicatorDirection = progressIndicatorDirection;
    });
  }

  void _setStyle(TimerStyle timerStyle) {
    setState(() {
      _timerStyle = timerStyle;
    });
  }

  void timerValueChangeListener(Duration timeElapsed) {
    // print(timeElapsed.toString());
  }

  void handleTimerOnStart() {
    print("timer has just started");
  }

  void handleTimerOnEnd() {
    print("timer has ended");
  }
}
