import 'package:flutter/material.dart';
import 'package:yarytefit/core/constants.dart';
class ActiveWorkouts extends StatelessWidget {
  const ActiveWorkouts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Active workouts', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: bgWhite,),),
    );
  }
}