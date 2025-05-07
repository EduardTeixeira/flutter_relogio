import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_relogio/widgets/input.widget.dart';
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
  final TextEditingController exerciseCtrl = TextEditingController(text: "60");
  final TextEditingController restCtrl = TextEditingController(text: "45");
  bool timeToRest = true;
  int timeSeconds = 0;

  double percent = 0.0;
  double slicePercent = 0.0;
  late Timer timer;

  void startTimer() {
    setTimeSeconds();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        print('\n\nPercent ::: $percent');
        print('slicePercent ::: $slicePercent');
        print('exerciseCtrl ::: $exerciseCtrl');
        print('exerciseCtrl ::: ${exerciseCtrl.text}');
        print('restCtrl ::: $restCtrl');
        print('restCtrl ::: ${restCtrl.text}');

        if (timeSeconds > 0) {
          print('IF --> timeSeconds ::: $timeSeconds');
          timeSeconds--;
          calculatePercent();
        } else {
          print('ELSE --> timeSeconds ::: $timeSeconds');
          timeToRest = !timeToRest;
          nextTimer();
          //timer.cancel();
        }
      });
    });
  }

  void setTimeSeconds() {
    if (timeToRest) {
      timeSeconds = int.parse(restCtrl.text);
    } else {
      timeSeconds = int.parse(exerciseCtrl.text);
    }
    slicePercent = 1.0 / timeSeconds;
  }

  void calculatePercent() {
    double futurePercent = percent + slicePercent;
    if (futurePercent > 1.0) {
      percent = 1.0;
    } else {
      percent += slicePercent;
    }
  }

  void nextTimer() {
    percent = 0.0;
    setTimeSeconds();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1542BF), Color(0xFF51A8FF)],
              begin: FractionalOffset(0.5, 1),
            ),
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Pomodoro",
                  style: TextStyle(color: Colors.white, fontSize: 50.0),
                ),
              ),
              Expanded(
                child: CircularPercentIndicator(
                  percent: percent,
                  animation: true,
                  lineWidth: 20.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  reverse: false,
                  animateFromLastPercent: true,
                  radius: 180.0,
                  progressColor: Colors.white,
                  center: Text(
                    "$timeSeconds seg",
                    style: TextStyle(color: Colors.white, fontSize: 40.0),
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                      left: 5.0,
                      right: 5.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Descanso",
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                    SizedBox(height: 10.0),
                                    Input(ctrl: restCtrl),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Exercício",
                                      style: TextStyle(fontSize: 25.0),
                                    ),
                                    SizedBox(height: 10.0),
                                    Input(ctrl: exerciseCtrl),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 28.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: startTimer,
                            child: Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text(
                                "Iniciar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                ),
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
}
