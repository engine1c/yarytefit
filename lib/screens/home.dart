import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:yarytefit/components/workout_active.dart';
import 'package:yarytefit/components/workouts_list.dart';
import 'package:yarytefit/core/constants.dart';
import 'package:yarytefit/domain/workout.dart';
import 'package:yarytefit/screens/add-workout-week.dart';
import 'package:yarytefit/screens/add-workout.dart';
import 'package:yarytefit/services/auth.dart';

class HomePage extends StatefulWidget {
  
  HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectionIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  WorkoutSchedule? workout; // Добавьте это

    @override
  void initState() {
    super.initState();
    workout = WorkoutSchedule(
      uid: '',
      author: '',
      title: '',
      description: '',
      level: '',
      weeks: []
    );
  }

  _changeTab(int index) {
    setState(() {
      selectionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var curvedNavigationBar = CurvedNavigationBar(
        items: const [
          Icon(Icons.fitness_center),
          Icon(Icons.search),
        ],
        key: _bottomNavigationKey,
        index: selectionIndex,
        height: 50,
        color: bgColorWhite,
        buttonBackgroundColor: bgWhite,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.bounceInOut,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index)=> _changeTab(index),
        );
        
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('やり手 FIT : ${selectionIndex==0 ? 'Active Workouts' : 'Find Workouts'}'),
        leading: const Icon(Icons.fitness_center),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await AuthService().logOut();
              },
              icon: const Icon(Icons.supervised_user_circle),
              label: const SizedBox.shrink())
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: selectionIndex==0 ? ActiveWorkouts() : WorkoutsList(),
      bottomNavigationBar: curvedNavigationBar,

floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.grey,
  foregroundColor: Theme.of(context).primaryColor,
  onPressed: () async {
    var week = await Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => AddWorkout(workoutSchedule: workout,)),
    );
    if (week != null) {
      setState(() {
        workout!.weeks.add(week);
      });
    }
  },
  child: const Icon(Icons.add),
),

    );
  }

// class WorkoutDetails extends StatefulWidget {
//   final String id;
//   WorkoutDetails({Key? key, required this.id}) : super(key: key);

//   @override
//   _WorkoutDetailsState createState() => _WorkoutDetailsState();
// }

// class _WorkoutDetailsState extends State<WorkoutDetails> {
//   // ... (your existing _WorkoutDetailsState code here)
// }

}