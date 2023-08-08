import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:yarytefit/components/common/save-button.dart';
import 'package:yarytefit/components/common/toast.dart';
import 'package:yarytefit/core/constants.dart';
import 'package:yarytefit/domain/myuser.dart';
import 'package:yarytefit/domain/workout.dart';
import 'package:yarytefit/screens/add-workout-week.dart';
import 'package:yarytefit/services/database.dart';
import 'package:provider/provider.dart';

class AddWorkout extends StatefulWidget {
  final WorkoutSchedule? workoutSchedule;

  AddWorkout({Key? key, required this.workoutSchedule}) : super(key: key);

  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final _fbKey = GlobalKey<FormBuilderState>();
  late MyUser user;
  WorkoutSchedule workout = WorkoutSchedule(
      uid: '', author: '', title: '', description: '', level: '', weeks: []);
  bool isNew = true;

  @override
  void initState() {
    if (widget.workoutSchedule != null) {
      isNew = false;
      workout = widget.workoutSchedule!.copy();
    }

      if(workout.level == null || workout.level.isEmpty )
      workout.level = 'Beginner';

    super.initState();
  }

  void _saveWorkout() async {
    if (_fbKey.currentState!.saveAndValidate()) {
      if (workout.weeks.isEmpty) {
        buildToast('Добавьте хотя бы одну тренировочную неделю');
        return;
      }

      //print(workout.toMap());
      if (workout.uid == null || workout.uid.isEmpty)  {
  workout.uid = user.id;
  workout.author = user.id;
      }

      await DatabaseService().addOrUpdateWorkout(workout);
      Navigator.of(context).pop(workout);
    } else {
      buildToast('Ooops! Что-то неправильно');
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser>(context);
    //WorkoutWeek mWeek = WorkoutWeek(days: [], notes: '');

    return Scaffold(
        appBar: AppBar(
          title: Text('yarytefit // ${isNew ? 'Create' : 'Edit'} Workout'),
          actions: <Widget>[SaveButton(onPressed: _saveWorkout)],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey,
          foregroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            var week = await Navigator.push<WorkoutWeek>(
              context,
              MaterialPageRoute(builder: (ctx) => AddWorkoutWeek()),
            );
            if (week != null) {
              setState(() {
                workout.weeks.add(week);
              });
            }
          },
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColorWhite),
            child: FormBuilder(
              key: _fbKey,
              autovalidateMode: AutovalidateMode.disabled,
              initialValue: const {},
              enabled: true,
             
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    style: const TextStyle(color: Colors.black87,),
                    initialValue: workout.title,
                    name: "title",
                    enabled: true,
                    enableInteractiveSelection: true,
                     decoration: const InputDecoration(
                      labelText: "Title*",
                    ),
                    onChanged: (dynamic val) {
                      setState(() {
                        workout.title = val;
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.maxLength(100),
                    ]),
                  ),
                  FormBuilderDropdown(
                    style: const TextStyle(color: Colors.black87,),
                    name: "level",
                    decoration: const InputDecoration(
                      labelText: "Select Level*",
                    ),
                    initialValue: workout.level,
                    //allowClear: false,
                    //hint: const Text('Select Level'),
                    onChanged: (dynamic val) {
                      setState(() {
                        workout.level = val;
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    items: <String>['Beginner', 'Intermediate', 'Advanced']
                        .map((level) => DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            ))
                        .toList(),
                  ),
                  FormBuilderTextField(
                     style: const TextStyle(color: Colors.black87,),
                    initialValue: workout.description,
                    name: "description",
                    decoration: const InputDecoration(
                      labelText: "Description*",
                    ),
                    onChanged: (dynamic val) {
                      setState(() {
                        workout.description = val;
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.maxLength(500),
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const <Widget>[
                      Text(
                        'Weeks*',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // FlatButton(
                      //   child: Icon(Icons.add),
                      //   onPressed: () async {
                      //     var week = await Navigator.push<WorkoutWeek>(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (ctx) => AddWorkoutWeek()));
                      //     if (week != null)
                      //       setState(() {
                      //         workout.weeks.add(week);
                      //       });
                      //   },
                      // )
                    ],
                  ),
                  workout.weeks.isEmpty
                      ? const Text(
                          'Добавьте хотя бы одну тренировочную неделю',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )
                      : _buildWeeks()
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildWeeks() {
    return Column(
        children: workout.weeks
            .map((mWeek) => Card(
                  elevation: 2.0,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                    onTap: () async {
                      var ind = workout.weeks.indexOf(mWeek);
                      var modifiedWeek = await Navigator.push<WorkoutWeek>(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => AddWorkoutWeek(week: mWeek)));
                      if (modifiedWeek != null) {
                        setState(() {
                          workout.weeks[ind] = modifiedWeek;
                        });
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(50, 65, 85, 0.9)),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        leading: Container(
                          padding: const EdgeInsets.only(right: 12),
                          decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1, color: Colors.white24))),
                          child: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                        title: Text(
                            'Week ${workout.weeks.indexOf(mWeek) + 1} - ${mWeek.daysWithDrills} Training Days',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .color,
                                fontWeight: FontWeight.bold)),
                        trailing: Icon(Icons.keyboard_arrow_right,
                            color:
                                Theme.of(context).textTheme.titleLarge!.color),
                      ),
                    ),
                  ),
                ))
            .toList());
  }
}
