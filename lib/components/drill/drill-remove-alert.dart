import 'package:flutter/material.dart';

Widget drillRemoveAlert(BuildContext context) {
  return AlertDialog(
    title: const Text('Удалить тренировку'),
    content: const Text(
      'Вы хотите удалить эту Тренировку??',
      style: TextStyle(fontSize: 20.0),
    ),
    actions: <Widget>[
      TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Yes')),
      TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('No')),
    ],
  );
}
