import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yarytefit/components/common/workout_level.dart';
import 'package:yarytefit/core/constants.dart';
import 'package:yarytefit/screens/workout_details.dart';
import 'package:yarytefit/domain/myuser.dart';
import 'package:yarytefit/domain/workout.dart';
import 'package:yarytefit/services/database.dart';
import 'package:provider/provider.dart';

class WorkoutsList extends StatefulWidget {
  //WorkoutsList();

  @override
  _WorkoutsListState createState() => _WorkoutsListState();
}

class _WorkoutsListState extends State<WorkoutsList> {
  late MyUser user;
  DatabaseService db = DatabaseService();

  @override
  void initState() {
    filter(clear: true);
    super.initState();
  }

  @override
  void dispose(){
  print('unsubscribing: workoutsStreamSubscription');
    workoutsStreamSubscription.cancel();
    super.dispose();
  }
  
  late StreamSubscription<List<Workout>> workoutsStreamSubscription;
  late var workouts = <Workout>[];

  var filterHeight = 0.0;
  var filterText = '';
  bool filterOnlyMyWorkouts = false;
  var filterTitle = '';
  var filterLevel = 'Any Level';
  var filterTitleController = TextEditingController();

  void filter({bool clear = false}) {
    if (clear) {
      filterOnlyMyWorkouts = false;
      filterTitle = '';
      filterLevel = 'Any Level';
      filterTitleController.clear();
    }

    setState(() {
      filterText = filterOnlyMyWorkouts ? 'Мои данные' : 'Все данные';
      filterText += '/$filterLevel';
      if (filterTitle.isNotEmpty) filterText += '/$filterTitle';
      filterHeight = 0;
    });

    loadData();
  }

  Future<void> loadData() async {
    var stream = db.getWorkouts(
        author: filterOnlyMyWorkouts ? user.id : '',
        level: filterLevel != 'Any Level' ? filterLevel : '');

    workoutsStreamSubscription = stream.listen((List<Workout> data) {
      setState(() {
        workouts = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser>(context);

    var filterInfo = Container(
      margin: const EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 5),
      decoration: BoxDecoration(color: bgWhite.withOpacity(0.5)),
      height: 40,
      child: ElevatedButton(
        child: Row(
          children: <Widget>[
            const Icon(Icons.filter_list),
            Text(
              filterText,
              style: const TextStyle(),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onPressed: () {
          setState(() {
            filterHeight = (filterHeight == 0.0 ? 220.0 : 0.0);
          });
        },
      ),
    );
    var levelMenuItems = <String>[
      'Any Level',
      'Beginner',
      'Intermediate',
      'Advanced'
    ].map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
    var filterForm = AnimatedContainer(
      margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: filterHeight,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SwitchListTile(
                  title: const Text('Только мои данные', style: TextStyle(color: Colors.black54),),
                  value: filterOnlyMyWorkouts,
                  onChanged: (bool val) =>
                      setState(() => filterOnlyMyWorkouts = val)),
              DropdownButtonFormField<String>(
                key: UniqueKey(),
                decoration: const InputDecoration(labelText: 'Level'),
                style: const TextStyle(color: Colors.black),
                hint: const Text("Select Level"),
                items: levelMenuItems,
                value: filterLevel,
                onChanged: (String? val) => setState(() => filterLevel = val!
                    // if(filterLevel.isNotEmpty){
                    //   filterLevel = val.toString();}
                    ),
              ),
              // TextFormField(
              //   controller: filterTitleController,
              //   decoration: const InputDecoration(labelText: 'Title'),
              //   onChanged: (String val) => setState(() => filterTitle = val),
              // ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        filter();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(color: bgWhite),),
                    ),
                  ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          filter(clear: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Clear',
                            style: TextStyle(color: bgWhite),),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
    var widgetsList = Expanded(
      child: ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, i) {
            return
            InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => WorkoutDetails(id: workouts[i].id),
      ),
    );
  },
            // InkWell(
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(builder: (ctx) => 
            //       WorkoutDetails(id:workouts[i].id))
            //       );
            //   },
              child: Card(
                key: Key(workouts[i].id),
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  decoration:
                      const BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.9)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: Container(
                      padding: const EdgeInsets.only(right: 12),
                      decoration: const BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(width: 1, color: Colors.white24))),
                      child: const Icon(Icons.fitness_center,
                          color: Colors.white54),// Theme.of(context).textTheme.titleLarge?.color),
                    ),
                    title: Text(workouts[i].title,
                        style: const TextStyle(
                            color: bgWhite,// Theme.of(context).textTheme.titleLarge?.color,
                            fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.keyboard_arrow_right,
                        color: bgWhite),//.of(context).textTheme.titleLarge?.color),
                    subtitle: 
                    Container(color: Colors.white24,child: WorkoutLevel(level: workouts[i].level),), 
                  ),
                ),
              ),
            );
          }),
    );

    return Column(children: [
      filterInfo,
      filterForm,
      widgetsList,
    ]);
  }
}


