//import 'package:flutter/cupertino.dart';

class Workout {
  late String id;
  late String title;
  late String author;
  late String description;
  late String level;
  late bool isOnline;

  Workout( {required this.id,  required this.title,  required this.author, 
            required  this.description,  required this.level, required this.isOnline});

  Workout.fromJson( String uid, Map<String, dynamic> data) {
    id = uid;
    title = data['title'];
    author = data['author'];
    description = data['description'];
    level = data['level'];
    isOnline = data['isOnline'];
  }
}

class WorkoutSchedule {
  late String uid;
  late String title;
  late String author;
  late String description;
  late String level;
  List<WorkoutWeek> weeks = []; // Инициализация пустым списком
  //List<WorkoutWeek> weeks;

  WorkoutSchedule(
      {required this.uid,
      required this.author,
      required this.title,
      required this.level,
      required this.description,
      required this.weeks});

  WorkoutSchedule copy() {
    var copiedWeeks = weeks.map((w) => w.copy()).toList();
    return WorkoutSchedule(
        uid: uid,
        author: author,
        title: title,
        level: level,
        description: description,
        weeks: copiedWeeks);
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "author": author,
      "description": description,
      "level": level,
      "weeks": weeks.map((w) => w.toMap()).toList()
    };
  }

  Map<String, dynamic> toWorkoutMap() {
    return {
      "title": title,
      "author": author,
      "description": description,
      "level": level,
      "isOnline": true,
      "createdOn": DateTime.now().millisecondsSinceEpoch
    };
  }

  WorkoutSchedule.fromJson( this.uid, Map<String, dynamic> data) {
     title = data['title'];
    author = data['author'];
    description = data['description'];
    level = data['level'];

    weeks = (data['weeks'] as List).map((w) => WorkoutWeek.fromJson(w)).toList();
  }
}

class WorkoutWeek {
  late String notes;
  List<WorkoutWeekDay> days = []; // Инициализация пустым списком;

  int get daysWithDrills =>
      days != null ? days.where((d) => d.isSet).length : 0;

  WorkoutWeek({required this.days, required this.notes}); 

  WorkoutWeek copy() {
    var copiedDays = days.map((w) => w.copy()).toList();

    return WorkoutWeek(days: copiedDays, notes: notes);
 
  }

  Map<String, dynamic> toMap() {
    return {
      "days": days.map((w) => w.toMap()).toList(),
      "notes": notes,

    };
  }

  WorkoutWeek.fromJson(Map<String, dynamic> value) {
    days =
        (value['days'] as List).map((w) => WorkoutWeekDay.fromJson(w)).toList();
         notes = value['notes'];

  }
}

class WorkoutWeekDay {
  String notes = '';
  List<WorkoutDrillsBlock> drillBlocks = [];

  bool get isSet => drillBlocks.isNotEmpty;
  int get notRestDrillBlocksCount => isSet
      ? drillBlocks.where((b) => b is! WorkoutRestDrillBlock).length
      : 0;
  int getNotRestDrillBlockIndex(WorkoutDrillsBlock block) => isSet
      ?  (drillBlocks.where((b) => b is! WorkoutRestDrillBlock).toList().indexOf(block))
      : -1;

  WorkoutWeekDay({required this.notes, required this.drillBlocks, });

  WorkoutWeekDay copy() {
    var copiedBlocks = drillBlocks.map((w) => w.copy()).toList();
    return WorkoutWeekDay(notes: notes, drillBlocks: copiedBlocks);
  }

  Map<String, dynamic> toMap() {
    return {
      "notes": notes,
      "drillBlocks": drillBlocks.map((w) => w.toMap()).toList()
    };
  }

  WorkoutWeekDay.fromJson(Map<String, dynamic> value) {
    notes = value['notes'];
    drillBlocks = (value['drillBlocks'] as List)
        .map((w) => WorkoutDrillsBlock.fromJson(w))
        .toList();
  }
}

class WorkoutDrill {
  late String title;
  late String weight;
  late int sets;
  late int reps;

   WorkoutDrill({ this.title='', this.weight='', this.sets=0,  this.reps=0});

  WorkoutDrill copy() {
    return WorkoutDrill(title: title, weight: weight, sets: sets, reps: reps);
  }

  Map<String, dynamic> toMap() {
    return {"title": title, "weight": weight, "sets": sets, "reps": reps};
  }

  WorkoutDrill.fromJson(Map<String, dynamic> value) {
    title = value['title'];
    weight = value['weight'];
    sets = value['sets'];
    reps = value['reps'];
  }
}

enum WorkoutDrillType {
  SINGLE,
  MULTISET,
  AMRAP,
  ForTime,
  EMOM,
  REST
  //TABATA
}

abstract class WorkoutDrillsBlock {
  WorkoutDrillType type;
  List<WorkoutDrill> drills;

  WorkoutDrillsBlock({required this.type, required this.drills});

  void changeDrillsCount(int count) {
    var diff = count - drills.length;

    if (diff == 0) return;

    if (diff > 0) {
      for (int i = 0; i < diff; i++) {
        drills.add(WorkoutDrill(reps: 0, sets: 0, title: '', weight: ''));
      }
    } else {
      drills = drills.sublist(0, drills.length + diff);
    }
  }

  WorkoutDrillsBlock copy();
  Map<String, dynamic> toMapParams();

  Map<String, dynamic> toMap() {
    var mainMap = {
      "type": type.toString(),
      "drills": drills.map((w) => w.toMap()).toList()
    };

    return {}..addAll(mainMap)..addAll(toMapParams());
  }

  factory WorkoutDrillsBlock.fromJson(Map<String, dynamic> value) {
    var type = value['type'];
    var drills = ((value['drills'] ?? List) as List)
        .map((d) => WorkoutDrill.fromJson(d))
        .toList();

    WorkoutDrillsBlock block;
    WorkoutDrillType drillType =
        WorkoutDrillType.values.firstWhere((e) => e.toString() == type);
    switch (drillType) {
      case WorkoutDrillType.AMRAP:
        block =
            WorkoutAmrapDrillBlock(drills: drills, minutes: value['minutes']);
        break;
      case WorkoutDrillType.SINGLE:
        block = WorkoutSingleDrillBlock(drill: drills[0]);
        break;
      case WorkoutDrillType.MULTISET:
        block = WorkoutMultisetDrillBlock(drills: drills);
        break;
      case WorkoutDrillType.ForTime:
        block = WorkoutForTimeDrillBlock(
            drills: drills,
            timeCapMin: value['timeCapMin'],
            rounds: value['rounds'],
            restBetweenRoundsMin: value['restBetweenRoundsMin']);
        break;
      case WorkoutDrillType.EMOM:
        block = WorkoutEmomDrillBlock(
            drills: drills,
            timeCapMin: value['timeCapMin'],
            intervalMin: value['intervalMin']);
        break;
      case WorkoutDrillType.REST:
        block = WorkoutRestDrillBlock(timeMin: value['timeMin']);
        break;
    }

    block.type = drillType;
    return block;
  }

  List<WorkoutDrill> copyDrills() {
    return drills.map((w) => w.copy()).toList();
  }
}

class WorkoutSingleDrillBlock extends WorkoutDrillsBlock {
  WorkoutSingleDrillBlock( {required WorkoutDrill drill})
      : super(type: WorkoutDrillType.SINGLE, drills: [drill]);

  @override
  WorkoutSingleDrillBlock copy() {
    return WorkoutSingleDrillBlock(drill: copyDrills()[0]);
  }

  @override
  Map<String, dynamic> toMapParams() {
    return {};
  }
}

class WorkoutMultisetDrillBlock extends WorkoutDrillsBlock {
  WorkoutMultisetDrillBlock({required List<WorkoutDrill> drills})
      : super(type: WorkoutDrillType.MULTISET, drills: drills);

  @override
  WorkoutMultisetDrillBlock copy() {
    return WorkoutMultisetDrillBlock(drills: copyDrills());
  }

  @override
  Map<String, dynamic> toMapParams() {
    return {};
  }
}

class WorkoutAmrapDrillBlock extends WorkoutDrillsBlock {
  int minutes;

  WorkoutAmrapDrillBlock(
      {required this.minutes, required List<WorkoutDrill> drills})
      : super(type: WorkoutDrillType.AMRAP, drills: drills);

  @override
  WorkoutAmrapDrillBlock copy() {
    return WorkoutAmrapDrillBlock(minutes: minutes, drills: copyDrills());
  }

  @override
  Map<String, dynamic> toMapParams() {
    return {"minutes": minutes};
  }
}

class WorkoutForTimeDrillBlock extends WorkoutDrillsBlock {
  int timeCapMin;
  int rounds;
  int restBetweenRoundsMin;

  WorkoutForTimeDrillBlock(
      {required this.timeCapMin,
      required this.rounds,
    required this.restBetweenRoundsMin,
    required List<WorkoutDrill> drills})
      : super(type: WorkoutDrillType.ForTime, drills: drills);

  @override
  WorkoutForTimeDrillBlock copy() {
    return WorkoutForTimeDrillBlock(
        timeCapMin: timeCapMin,
        rounds: rounds,
        restBetweenRoundsMin: restBetweenRoundsMin,
        drills: copyDrills());
  }

  @override
  Map<String, dynamic> toMapParams() {
    return {
      "timeCapMin": timeCapMin,
      "rounds": rounds,
      "restBetweenRoundsMin": restBetweenRoundsMin
    };
  }
}

class WorkoutEmomDrillBlock extends WorkoutDrillsBlock {
  int timeCapMin;
  int intervalMin;

  WorkoutEmomDrillBlock(
      {required this.timeCapMin,
      required this.intervalMin,
      required List<WorkoutDrill> drills})
      : super(type: WorkoutDrillType.EMOM, drills: drills);

  @override
  WorkoutEmomDrillBlock copy() {
    return WorkoutEmomDrillBlock(
        timeCapMin: timeCapMin, intervalMin: intervalMin, drills: copyDrills());
  }

  @override
  Map<String, dynamic> toMapParams() {
    return {"timeCapMin": timeCapMin, "intervalMin": intervalMin};
  }
}

class WorkoutRestDrillBlock extends WorkoutDrillsBlock {
  int timeMin;

  WorkoutRestDrillBlock({required this.timeMin})
      : super(type: WorkoutDrillType.REST, drills: []);

  @override
  WorkoutRestDrillBlock copy() {
    return WorkoutRestDrillBlock(timeMin: timeMin);
  }

  @override
  Map<String, dynamic> toMapParams() {
    return {
      "timeMin": timeMin,
    };
  }
}
