import 'package:flutter/material.dart';
import 'package:yarytefit/core/constants.dart';

class WorkoutLevel extends StatelessWidget {
  final String level;
  const WorkoutLevel({Key? key, required this.level}) : super(key: key);

Widget getLevel(BuildContext context, String level) {
  var color = bgWhite;
  double indicatorLevel = 0;

  switch (level) {
    case 'Beginner':
      color = Colors.green;
      indicatorLevel = 0.33;
      break;
    case 'Intermediate':
      color = Colors.yellow;
      indicatorLevel = 0.66;
      break;
    case 'Advanced':
      color = Colors.red;
      indicatorLevel = 1;
      break;
  }

  return Row(
    children: <Widget>[
      Expanded(
          flex: 1,
          child: LinearProgressIndicator(
              backgroundColor: bgWhite,// Theme.of(context).textTheme.titleLarge?.color,
              value: indicatorLevel,
              valueColor: AlwaysStoppedAnimation(color))),
      const SizedBox(width: 10),
      Expanded(
          flex: 3,
          child: Text(level,
              style: const TextStyle(color: bgWhite ))),//Theme.of(context).textTheme.titleLarge?.color)))
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getLevel(context, level),
    );
  }
}