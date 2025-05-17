import 'package:flutter/material.dart';
import 'package:flutter_relogio/enums/timer_action.dart';

class IconTimer extends StatelessWidget {
  final Icon icon;
  final TimerAction timerAction;

  const IconTimer({super.key, required this.icon, required this.timerAction});

  action() {
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
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.black,
        shape: CircleBorder(),
      ),
      child: IconButton(
        icon: icon,
        iconSize: 32,
        color: Colors.white,
        tooltip: 'Play timer.',
        onPressed: action,
      ),
    );
  }
}
