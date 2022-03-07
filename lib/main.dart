import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_equations/stress_and_recovery_functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_equations/analysis.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Ekvationer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<ActivityEvent>? activityStreamSubscription;
  final List<ActivityEvent> _events = [];
  ActivityEvent _activityEvent = ActivityEvent(ActivityType.UNKNOWN, 0);
  ActivityRecognition activityRecognition = ActivityRecognition();

  List<int> RR = [];

  late Timer rrTimer;
  late Timer oneMinuteTimer;
  late Timer fiveMinuteTimerOnce;
  late Timer fiveMinuteTimerPeriodic;
  late Timer dayTimer;
  late Timer tenSecTimer;
  late StreamController<String> rmssdStreamController;
  late StreamController<String> hrStreamController;
  late StreamController<String> movementStreamController;
  late StreamController<String> conditionStreamController;
  late AnalysisService analysis;
  Random random = Random();

  @override
  void initState() {
    rmssdStreamController = StreamController();
    movementStreamController = StreamController();
    hrStreamController = StreamController();
    conditionStreamController = StreamController();
    analysis = AnalysisService();
    _init();
    _events.add(ActivityEvent.unknown());
    super.initState();
  }

  @override
  void dispose() {
    activityStreamSubscription?.cancel();
    super.dispose();
  }

  void _init() async {
    // Android requires explicitly asking permission
    if (Platform.isAndroid) {
      if (await Permission.activityRecognition.request().isGranted) {
        _startTracking();
      }
    }

    // iOS does not
    else {
      _startTracking();
    }
  }

  void _startTracking() {
    activityStreamSubscription = activityRecognition
        .activityStream(runForegroundService: true)
        .listen(onData, onError: onError);
  }

  void onData(ActivityEvent activityEvent) {
    print(activityEvent);
    _activityEvent = activityEvent;
    setState(() {
      _events.add(activityEvent);
    });
  }

  void onError(Object error) {
    print('ERROR - $error');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ElevatedButton(
                onPressed: startRecording, child: const Text("Start mätning")),
            ElevatedButton(
                onPressed: stopRecording, child: const Text("Avsluta mätning")),
            StreamBuilder(
                stream: rmssdStreamController.stream,
                builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
                  return SizedBox(
                    height: 50,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            'RMSSD: ${snapshot.hasData ? snapshot.data.toString() : ""}')),
                  );
                }),
            StreamBuilder(
                stream: hrStreamController.stream,
                builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
                  return SizedBox(
                    height: 50,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            'HR: ${snapshot.hasData ? snapshot.data.toString() : ""}')),
                  );
                }),
            StreamBuilder(
                stream: movementStreamController.stream,
                builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
                  return SizedBox(
                    height: 50,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            'Moving: ${snapshot.hasData ? snapshot.data.toString() : ""}')),
                  );
                }),
            StreamBuilder(
                stream: conditionStreamController.stream,
                builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
                  return SizedBox(
                    height: 50,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            'Condition: ${snapshot.hasData ? snapshot.data.toString() : ""}')),
                  );
                }),
            SizedBox(
              height: 300,
              child: ListView.builder(
                  itemCount: _events.length,
                  reverse: true,
                  itemBuilder: (_, int idx) {
                    final activity = _events[idx];
                    return ListTile(
                      leading: _activityIcon(activity.type),
                      title: Text(
                          '${activity.type.toString().split('.').last} (${activity.confidence}%)'),
                      trailing: Text(activity.timeStamp
                          .toString()
                          .split(' ')
                          .last
                          .split('.')
                          .first),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void startRecording() {
    // generate random RR values between 700-800 and add to array dynamically increasing sliding window
    rrTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int rr = random.nextInt(100) + 700;
      RR.add(rr);
      //TODO: save RR to CSV file
    });

    DateTime now = DateTime.now();
    DateTime end = DateTime(now.year, now.month, now.day, 24, 0);
    // set timer that will trigger by the end of the day 24:00
    dayTimer = Timer(Duration(seconds: end.difference(now).inSeconds), () {
      if (rrTimer.isActive) rrTimer.cancel();
      if (oneMinuteTimer.isActive) oneMinuteTimer.cancel();
      if (fiveMinuteTimerOnce.isActive) fiveMinuteTimerOnce.cancel();
      if (fiveMinuteTimerPeriodic.isActive) fiveMinuteTimerPeriodic.cancel();
      if (tenSecTimer.isActive) tenSecTimer.cancel();
      // TODO: Send files to storage
    });

    // timer after 1 min
    oneMinuteTimer = Timer(const Duration(seconds: 10), () {
      tenSecTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        var Ri = analysis.rmssdCalc(RR);
        var Pi = analysis.hrCalc(RR);
        rmssdStreamController.add(Ri.toString());
        hrStreamController.add(Pi.toString());

        var isMoving = checklIfIsMoving(_activityEvent);
        movementStreamController.add(isMoving.toString());

        var condition = checkForCondition(Ri, Pi, isMoving, 40, 60);

        condition != null
            ? conditionStreamController.add(condition.message)
            : conditionStreamController.add('');
      });
      oneMinuteTimer.cancel();
    });

    fiveMinuteTimerOnce = Timer(const Duration(seconds: 30), () {
      if (rrTimer.isActive) rrTimer.cancel();

      rrTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        int rr = random.nextInt(100) + 700;
        RR.add(rr);
        RR.removeAt(0);
        //TODO: save RR to CSV file
      });
      fiveMinuteTimerOnce.cancel();
    });

    fiveMinuteTimerPeriodic =
        Timer.periodic(const Duration(seconds: 300), (timer) {
      //TODO: save Ri, HR, Move, MentalStress, PhysicalStress, Recovery to CSV-file
    });
  }

  void stopRecording() {
    if (dayTimer.isActive) dayTimer.cancel();
    if (rrTimer.isActive) rrTimer.cancel();
    if (oneMinuteTimer.isActive) oneMinuteTimer.cancel();
    if (fiveMinuteTimerOnce.isActive) fiveMinuteTimerOnce.cancel();
    if (fiveMinuteTimerPeriodic.isActive) fiveMinuteTimerPeriodic.cancel();
    if (tenSecTimer.isActive) tenSecTimer.cancel();

    rmssdStreamController.add("");
    hrStreamController.add("");
    movementStreamController.add("");
    conditionStreamController.add("");
  }

  Widget buildItem(String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return page;
        }));
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        color: Colors.blue,
        width: double.infinity,
        alignment: Alignment.center,
        height: 100,
        child: Text(
          title,
          style: const TextStyle(fontSize: 36),
        ),
      ),
    );
  }

  Icon _activityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.WALKING:
        return Icon(Icons.directions_walk);
      case ActivityType.IN_VEHICLE:
        return Icon(Icons.car_rental);
      case ActivityType.ON_BICYCLE:
        return Icon(Icons.pedal_bike);
      case ActivityType.ON_FOOT:
        return Icon(Icons.directions_walk);
      case ActivityType.RUNNING:
        return Icon(Icons.run_circle);
      case ActivityType.STILL:
        return Icon(Icons.cancel_outlined);
      case ActivityType.TILTING:
        return Icon(Icons.redo);
      default:
        return Icon(Icons.device_unknown);
    }
  }
}
