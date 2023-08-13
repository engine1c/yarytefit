import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yarytefit/components/common/workout-level.dart';
import 'package:yarytefit/core/constants.dart';
import 'package:yarytefit/domain/myuser.dart';
import 'package:yarytefit/domain/workout.dart';
import 'package:yarytefit/screens/add-workout.dart';
import 'package:yarytefit/services/database.dart';
import 'package:provider/provider.dart';

class WorkoutDetails extends StatefulWidget {
  final String id;
  const WorkoutDetails({Key? key, required this.id,}) : super(key: key);

  @override
  _WorkoutDetailsState createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  late WorkoutSchedule workout;
  late MyUser user;
  var db = DatabaseService();
  bool isLoading = true; // Добавляем состояние загрузки


  @override
  void initState() {
    _loadWorkout();
    super.initState();
  }


// Future<void> _loadWorkout() async {
//     final w = await db.getWorkout(widget.id);
//     setState(() {
//       workout = w;
//     });
//   }  
  
void _loadWorkout() {
  db.getWorkout(widget.id).then((w) {
    if (w != null) {
      setState(() {
        workout = w;
        isLoading = false; // Помечаем загрузку завершенной
      });
    } else {
      // Обработка случая, когда данные не были загружены (например, вывод ошибки)
      print("Ошибка: Данные не были загружены.");
    }
  });
}

  bool _isAuthor() =>
      user != null && workout != null && user.id == workout.author;

  Widget _buildHeader(BuildContext context) => Stack(children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gym.jpg'),
                fit: BoxFit.cover
              )
            ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Color.fromRGBO(58, 68, 85, .9)),
          child: Center(
            child: _buildTopContentText(),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back, color: Colors.amber),
              ),
              _isAuthor()
                  ? IconButton(
                      icon: const Icon(Icons.edit),
                      color: bgWhite,
                      onPressed: () async {
                        var updatedWorkout =
                            await Navigator.push<WorkoutSchedule>(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => AddWorkout(
                                          workoutSchedule: workout,
                                        )));
                        if (updatedWorkout != null) _loadWorkout();
                      },
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ]);

  Widget _buildTopContentText() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 60.0),
          Text(
            workout.title,
            style: const TextStyle(color: bgWhite, fontSize: 30.0),
          ),
          const SizedBox(height: 20.0),
          Text(
            workout.description,
            style: const TextStyle(color: bgWhite, fontSize: 20.0),
            maxLines: 5,
          ),
          const SizedBox(height: 20.0),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              WorkoutLevel(level: workout.level),
            ],
          ))
        ],
      );

  Widget _buildWorkoutDay(WorkoutWeekDay day) => Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        color: bgColorActive2,
        child: Column(
          children: (day.drillBlocks.isEmpty)
              ? <Widget>[
                  const Text(
                      'Relax, even machines need rest... well at least sometimes! Ok, ok, you can do some active recovery today',
                      style: TextStyle(
                          color: bgWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))
                ]
              : day.drillBlocks
                  .map((block) => _buildDrillBlock(
                      block, day.getNotRestDrillBlockIndex(block)))
                  .toList(),
        ),
      );

  Widget _bildDrill(WorkoutDrill drill, int index, bool single) => ListTile(
        title: Text(
          '${single ? '' : '${index + 1}) '}${drill.title}',
          style: TextStyle(
              color: bgWhite,
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${drill.sets}x${drill.reps}',
                style: TextStyle(
                    color: bgWhite,
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                    fontStyle: FontStyle.italic)),
            (drill.weight.isNotEmpty)
                ? Text('with weight: ${drill.weight}',
                    style: TextStyle(
                        color: bgWhite,
                        fontSize:
                            Theme.of(context).textTheme.titleLarge?.fontSize,
                        fontStyle: FontStyle.italic))
                : const SizedBox.shrink()
          ],
        ),
      );

  Widget _buildDrillBlock(WorkoutDrillsBlock block, int index) {
    Widget widget = const SizedBox.shrink();

    var workoutDrills = block.drills
        .map((drill) => _bildDrill(
            drill, block.drills.indexOf(drill), block.drills.length == 1))
        .toList();

    switch (block.type) {
      case WorkoutDrillType.SINGLE:
        widget = Container(
            color: bgColorActive3,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: <Widget>[
                const Text(
                  'Single',
                  style: TextStyle(
                      color: bgWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ...workoutDrills
              ],
            ));
        break;
      case WorkoutDrillType.MULTISET:
        widget = Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: bgColorActive3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'MultiSet',
                  style: TextStyle(
                      color: bgWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ...workoutDrills
              ],
            ));
        break;
      case WorkoutDrillType.AMRAP:
        var amrapBlock = block as WorkoutAmrapDrillBlock;
        widget = Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: bgColorActive3,
            child: Column(
              children: <Widget>[
                const Text('AMRAP',
                    style: TextStyle(
                        color: bgWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text('${amrapBlock.minutes} min',
                    style: const TextStyle(
                        color: bgWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                ...workoutDrills
              ],
            ));
        break;
      case WorkoutDrillType.ForTime:
        var forTimeBlock = block as WorkoutForTimeDrillBlock;
        widget = Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: bgColorActive3,
            child: Column(
              children: <Widget>[
                const Text('For Time',
                    style: TextStyle(
                        color: bgWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                forTimeBlock.rounds > 1
                    ? Text('${forTimeBlock.rounds} rounds',
                        style: const TextStyle(
                            color: bgWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))
                    : const SizedBox.shrink(),
                forTimeBlock.restBetweenRoundsMin > 0
                    ? Text(
                        '${forTimeBlock.restBetweenRoundsMin} min rest between rounds',
                        style: const TextStyle(
                            color: bgWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))
                    : const Text('Нет отдыха',
                        style: TextStyle(
                            color: bgWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                Text('${forTimeBlock.timeCapMin} min time cap',
                    style: const TextStyle(
                        color: bgWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                ...workoutDrills
              ],
            ));
        break;
      case WorkoutDrillType.EMOM:
        var emomBlock = block as WorkoutEmomDrillBlock;
        widget = Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: bgColorActive3,
            child: Column(
              children: <Widget>[
                const Text('EMOM',
                    style: TextStyle(
                        color: bgWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text('every ${emomBlock.intervalMin} min',
                    style: const TextStyle(
                        color: bgWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('for total ${emomBlock.timeCapMin} min',
                    style: const TextStyle(
                        color: bgWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                ...workoutDrills
              ],
            ));
        break;
      case WorkoutDrillType.REST:
        widget = Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: bgColorRest,
            child: ListTile(
              title: Text(
                  'Rest ${(block as WorkoutRestDrillBlock).timeMin} min',
                  style: const TextStyle(
                      color: bgWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ));
        break;
    }

    return Stack(
      children: <Widget>[
        widget,
        index >= 0
            ? Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: 30,
                  height: 20,
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                        child: Text('${index + 1}',
                            style: const TextStyle(
                                color: bgWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.bold))),
                  ),
                ))
            : const SizedBox.shrink()
      ],
    );
  }

  Widget _buildWorkoutWeek(WorkoutWeek week) => Column(
        children: week.days
            .map((day) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: const BoxDecoration(color: bgColorActive2),
                  child: ExpansionTileCard(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    baseColor: bgColorInactive,
                    expandedColor: bgColorActive2,
                    leading: Container(
                      padding: const EdgeInsets.only(right: 12),
                      decoration: const BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(width: 1, color: Colors.white24))),
                      child: day.isSet
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.hourglass_empty,
                              color: Colors.blue,
                            ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'День(2) ${week.days.indexOf(day) + 1} - ${day.isSet
                                    ? '${day.notRestDrillBlocksCount} drills'
                                    : 'День отдыха(2)'}',
                            style: const TextStyle(
                                color: bgWhite,
                                fontWeight: FontWeight.bold)),
                        day.notes.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.info),
                                color: bgWhite,
                                onPressed: () {
                                  _showNotes(
                                      'Day ${week.days.indexOf(day) + 1} notes',
                                      day.notes);
                                },
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                    children: <Widget>[_buildWorkoutDay(day)],
                    // trailing: Icon(Icons.keyboard_arrow_right,
                    //     color: Theme.of(context).textTheme.title.color),
                  ),
                ))
            .toList(),
      );

  Future<void> _showNotes(String title, String notes) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(notes),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildWorkoutWeeks() => Column(
      children: workout.weeks
          .map((week) => Container(
                padding: const EdgeInsets.only(top: 5),
                //decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                child: ExpansionTileCard(
                  baseColor: bgColorInactive,
                  expandedColor: bgColorActive,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Неделя ${workout.weeks.indexOf(week) + 1} - ${week.daysWithDrills} Тренировочные дни',
                          style: const TextStyle(
                              color: bgWhite,
                              fontWeight: FontWeight.bold)),
                      week.notes.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.info),
                              color: bgWhite,
                              onPressed: () {
                                _showNotes(
                                    'Неделя(Прим) ${workout.weeks.indexOf(week) + 1} notes',
                                    week.notes);
                              },
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                  children: <Widget>[_buildWorkoutWeek(week)],
                ),
              ))
          .toList());

  @override
  Widget build(BuildContext context) {
    user = Provider.of<MyUser>(context);

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
      body: isLoading // Показываем индикатор загрузки, если данные еще не загружены
          ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildHeader(context),
                    _buildWorkoutWeeks()
                  ],
                ),
              ));
  }
}
