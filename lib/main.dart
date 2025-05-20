import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_relogio/enums/timer_action.dart';
import 'package:flutter_relogio/widgets/icon-timer.widget.dart';
import 'package:flutter_relogio/widgets/input.widget.dart';
import 'package:flutter_relogio/widgets/text-info.widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() => runApp(
  MaterialApp(debugShowCheckedModeBanner: false, home: CountDownTimer()),
);

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key});
  @override
  CountDownTimerState createState() => CountDownTimerState();
}

class CountDownTimerState extends State<CountDownTimer> {
  LinearGradient backgroundColor = LinearGradient(
    colors: [Color(0xFF1542BF), Color(0xFF51A8FF)],
    begin: FractionalOffset(0.5, 1),
  );
  String centralText = "Pomodoro";
  final TextEditingController exerciseCtrl = TextEditingController(text: "60");
  final TextEditingController restCtrl = TextEditingController(text: "45");
  Timer? timer;
  bool timerActive = false;
  bool timeToRest = true;
  int timeSeconds = 0;
  final double maxPercent = 1.0;
  double percent = 0.0;
  double slicePercent = 0.0;

  void startTimer(bool isStart) {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    if (isStart) {
      timeToRest = true;
    }
    setTimeSeconds();
    timerActive = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeSeconds > 0) {
          timeSeconds--;
          calculatePercent();
        } else {
          nextTimer();
        }
      });
    });
  }

  void setTimeSeconds() {
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

  void nextTimer() {
    timeToRest = !timeToRest;
    setTimeSeconds();
  }

  action(timerAction) {
    switch (timerAction) {
      case TimerAction.pause:
        print('TimerAction.pause');
      case TimerAction.play:
        print('TimerAction.play');
      case TimerAction.restore:
        print('TimerAction.restore');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(gradient: backgroundColor),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextInfo(label: centralText, fontSize: 50.0),
              ),
              Expanded(
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
                                timerActive
                                    ? [
                                      IconTimer(
                                        icon: const Icon(Icons.pause),
                                        timerAction: TimerAction.pause,
                                        onPressed: action,
                                      ),
                                      const SizedBox(width: 10),
                                      IconTimer(
                                        icon: const Icon(Icons.refresh),
                                        timerAction: TimerAction.restore,
                                        onPressed: action,
                                      ),
                                    ]
                                    : [
                                      IconTimer(
                                        icon: const Icon(Icons.play_arrow),
                                        timerAction: TimerAction.play,
                                        onPressed: action,
                                      ),
                                    ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
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
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    TextInfo(label: "Descanso", fontSize: 25.0),
                                    SizedBox(height: 5.0),
                                    Input(ctrl: restCtrl),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    TextInfo(
                                      label: "Exercício",
                                      fontSize: 25.0,
                                    ),
                                    SizedBox(height: 5.0),
                                    Input(ctrl: exerciseCtrl),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              startTimer(true);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(14.0),
                              child: TextInfo(label: "Iniciar", fontSize: 25.0),
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
}
