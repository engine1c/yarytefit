
import 'package:flutter/material.dart';
import 'package:yarytefit/domain/workout.dart';
import 'package:yarytefit/sevices/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('やり手 FIT'),
        leading: const Icon(Icons.fitness_center),
        actions: [
          TextButton.icon(
            onPressed: () async { await AuthService().logOut(); 
            } , 
        icon: Icon(Icons.supervised_user_circle), 
        label: SizedBox.shrink()
        )
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: WorkoutList(),
    );
  }
}

class WorkoutList extends StatelessWidget {
  final workouts = <Workout>[
    Workout(
        title: 'Text1',
        autor: 'YARYTЭ1',
        description: 'Test Workout1',
        level: 'Beginner'),
    Workout(
        title: 'Text2',
        autor: 'YARYTЭ2',
        description: 'Test Workout2',
        level: 'Intermediate'),
    Workout(
        title: 'Text3',
        autor: 'YARYTЭ3',
        description: 'Test Workout3',
        level: 'Advansed'),
    Workout(
        title: 'Text4',
        autor: 'YARYTЭ4',
        description: 'Test Workout4',
        level: 'Beginner'),
    Workout(
        title: 'Text5',
        autor: 'YARYTЭ5',
        description: 'Test Workout5',
        level: 'Intermediate'),
  ];

    @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, i) {
            return Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                decoration:
                    const BoxDecoration(color: Color.fromRGBO(50, 65, 85, .8)),
                child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: Container(
                      padding: const EdgeInsets.only(right: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 1,color: Colors.white38)
                            )
                          ),
                      child:
                          const Icon(Icons.fitness_center_sharp, color: Colors.white),
                    ),
                    textColor: Colors.white,
                    title: Text(workouts[i].title),
                    trailing: const Icon(Icons.keyboard_arrow_right,color: Colors.white,),
                    subtitle: subtitle(context,workouts[i]),
                    ),
                    
              ),
            );
          }),
    );
  }
}

Widget subtitle(BuildContext context, Workout workout){
  var color = Colors.grey;

  double indlev = 0;
  switch(workout.level){
    case 'Beginner':
    color = Colors.green;
    indlev = 0.33;
    break;
  
    case 'Intermediate':
    color = Colors.yellow;
    indlev = 0.66;
    break;
      case 'Advansed':
    color = Colors.red;
    indlev = 1;
    break;
   }
  return Row(
    children: <Widget>[
      Expanded( 
      flex: 1,
      child: LinearProgressIndicator(
      backgroundColor: Colors.white,
      value: indlev,
      valueColor: AlwaysStoppedAnimation(color),
      )
      ),
      const SizedBox(width: 10,),
      Expanded(flex: 3,
      child: Text(workout.level, style: const TextStyle(color: Colors.white60),),
      )
    ]
    
  );
}
