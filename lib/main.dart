import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_relogio/enums/timer_action.dart';
import 'package:flutter_relogio/widgets/icon-timer.widget.dart';
import 'package:flutter_relogio/widgets/input.widget.dart';
import 'package:flutter_relogio/widgets/text-info.widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() => runApp(
  MaterialApp(debugShowCheckedModeBanner: false, home: const CountDownTimer()),
);

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key});
  @override
  CountDownTimerState createState() => CountDownTimerState();
}

class CountDownTimerState extends State<CountDownTimer> {
  final _labelSize = 20.0;

  LinearGradient backgroundColor = LinearGradient(
    colors: [Color(0xFF1542BF), Color(0xFF51A8FF)],
    begin: FractionalOffset(0.5, 1),
  );
  String centralText = "Pomodoro";

  final TextEditingController exerciseCtrl = TextEditingController(text: "60");
  final TextEditingController restCtrl = TextEditingController(text: "45");

  Timer? timer;
  bool timerRunning = false;
  bool timeToRest = true;
  int timeSeconds = 0;

  final double maxPercent = 1.0;
  double percent = 0.0;
  double slicePercent = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(gradient: backgroundColor),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextInfo(label: centralText, fontSize: 50.0),
              Expanded(
                flex: 6,
                child: CircularPercentIndicator(
                  percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  reverse: false,
                  lineWidth: 20.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  radius: 180.0,
                  progressColor: Colors.white,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextInfo(label: "$timeSeconds seg", fontSize: 50.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                timerRunning
                                    ? [
                                      IconTimer(
                                        icon: const Icon(Icons.pause),
                                        timerAction: TimerAction.pause,
                                        onPressed: actions,
                                      ),
                                      const SizedBox(width: 10),
                                      IconTimer(
                                        icon: const Icon(Icons.refresh),
                                        timerAction: TimerAction.restore,
                                        onPressed: actions,
                                      ),
                                      const SizedBox(width: 10),
                                      IconTimer(
                                        icon: const Icon(Icons.skip_next),
                                        timerAction: TimerAction.next,
                                        onPressed: actions,
                                      ),
                                    ]
                                    : [
                                      IconTimer(
                                        icon: const Icon(Icons.play_arrow),
                                        timerAction: TimerAction.play,
                                        onPressed: actions,
                                      ),
                                    ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      left: 10.0,
                      right: 10.0,
                      bottom: 10.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  TextInfo(
                                    label: "Descanso",
                                    fontSize: _labelSize,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Input(ctrl: restCtrl),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  TextInfo(
                                    label: "Exercício",
                                    fontSize: _labelSize,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Input(ctrl: exerciseCtrl),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              startTimer(true);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: TextInfo(
                                label: "Iniciar",
                                fontSize: _labelSize,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //timer?.cancel();
    print('object ---> dispose()...');
  }

  void actions(timerAction) {
    switch (timerAction) {
      case TimerAction.play:
        startTimer(timerRunning);
      case TimerAction.pause:
        pauseTimer();
      case TimerAction.restore:
        setTimeSeconds();
      case TimerAction.next:
        nextTimer();
    }
  }

  void pauseTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      setState(() {
        timerRunning = false;
      });
    }
  }

  void nextTimer() {
    timeToRest = !timeToRest;
    setTimeSeconds();
  }

  void startTimer(bool isStart) {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }

    print('startTimer - isStart ${isStart}');

    if (isStart) {
      print('IF -> timerRunning ===> ${timerRunning}');
      setTimeSeconds();
    } else {
      print('ELSE -> timerRunning ===> ${timerRunning}');
    }

    timerRunning = true;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeSeconds > 0) {
          timeSeconds--;
          calculatePercent();
        } else {
          print('proximo timer -> timer');
          nextTimer();
        }
      });
    });
  }

  void setTimeSeconds() {
    print('set Time Seconds ()');
    if (timeToRest) {
      timeSeconds = int.parse(restCtrl.text);
      backgroundColor = LinearGradient(
        colors: [Colors.green, Colors.lightGreen],
        begin: FractionalOffset(0.5, 1),
      );
      centralText = "Descanso";
    } else {
      timeSeconds = int.parse(exerciseCtrl.text);
      backgroundColor = LinearGradient(
        colors: [Colors.red, Colors.orange],
        begin: FractionalOffset(0.5, 1),
      );
      centralText = "Exercício";
    }
    slicePercent = maxPercent / timeSeconds;
    percent = 0.0;
  }

  void calculatePercent() {
    double futurePercent = percent + slicePercent;
    if (futurePercent > maxPercent) {
      percent = maxPercent;
    } else {
      percent += slicePercent;
    }
  }
}
