import 'package:flutter/material.dart';
import 'package:flutter_relogio/enums/timer_action.dart';

class IconTimer extends StatelessWidget {
  final Icon icon;
  final TimerAction timerAction;
  final Function(TimerAction) onPressed;

  const IconTimer({
    super.key,
    required this.icon,
    required this.timerAction,
    required this.onPressed,
  });

  snackBarText() {
    switch (timerAction) {
      case TimerAction.pause:
        return 'Parou o timer';
      case TimerAction.play:
        return 'Iniciou o timer';
      case TimerAction.restore:
        return 'Reiniciou o timer';
    }
  }

  snackBarAction() {
    switch (timerAction) {
      case TimerAction.pause:
        return 'Pausar';
      case TimerAction.play:
        return 'Iniciar';
      case TimerAction.restore:
        return 'Reiniciar';
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
        onPressed: () {
          onPressed(timerAction);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snackBarText()),
              duration: Duration(seconds: 2),
              action: SnackBarAction(
                label: snackBarAction(),
                backgroundColor: Colors.white,
                textColor: Colors.red,
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
