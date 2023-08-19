import 'package:firebase_auth/firebase_auth.dart';
import 'package:yarytefit/domain/workout.dart';

class profuser{
  late String id;
  late UserData userData;

// class MyUser{
//   late String id;
//    MyUser.fromFirebase(User? user){
//     id = user!.uid;
//   }
// }

  profuser.fromFirebase(User? fUser){
    id = fUser!.uid;
  }

  void setUserData(UserData userData){
    this.userData = userData;
  }

  bool hasActiveWorkout(String uid)=> userData != null && userData.workouts != null
    && userData.workouts.any((w) => w.workoutId == uid && w.completedOnMs == null);

  List<String> get workoutIds => userData != null && userData.workouts != null
    ? userData.workouts.map((e) => e.workoutId).toList()
    : <String>[];
}

class UserData {
  late String uid;
  late List<UserWorkout> workouts;

  Map<String, dynamic> toMap(){
    return {
      "workouts": workouts == null ? [] : workouts.map((w) => w.toMap()).toList()
    };
  }

    UserData();

  UserData.fromJson(this.uid, Map<String, dynamic> data){
    if(data['workouts'] == null) {
      workouts = <UserWorkout>[];
    } else {
      workouts = (data['workouts'] as List).map((w) => UserWorkout.fromJson(w)).toList();
    }
  }

    bool hasActiveWorkout(String uid)=> workouts != null
          && workouts.any((w) => w.workoutId == uid && w.completedOnMs == null);


  void addUserWorkout(UserWorkout userWorkout) {
    if(workouts == null) {
      workouts = <UserWorkout>[];
    }

    workouts.add(userWorkout);
  }
}

class UserWorkout{
  late String workoutId;
  late List<UserWorkoutWeek> weeks;
  late int lastWeek;
  late int lastDay;
  late int loadedOnMs;
  late int completedOnMs;

  Map<String, dynamic> toMap() {
      return {
        "workoutId": workoutId,
        "lastWeek": lastWeek,
        "lastDay": lastDay,
        "loadedOnMs": loadedOnMs,
        "completedOnMs": completedOnMs,
        "weeks": weeks.map((w) => w.toMap()).toList(),
      };
    }

  UserWorkout.fromJson(Map<String, dynamic> value){
    workoutId = value['workoutId'];
    lastWeek = value['lastWeek'];
    lastDay = value['lastDay'];
    loadedOnMs = value['loadedOnMs'];
    completedOnMs = value['completedOnMs'];
    weeks = (value['weeks'] as List).map((w) => UserWorkoutWeek.fromJson(w)).toList();
  }

  UserWorkout.fromWorkout(WorkoutSchedule workout){
    workoutId = workout.uid;
    weeks = workout.weeks.map((e){
      final days = [for(var i=0; i < e.days.length; i+=1) UserWorkoutDay.empty()].toList();
      final week = UserWorkoutWeek(days);
      return week;
    }).toList();

    loadedOnMs = DateTime.now().millisecondsSinceEpoch;
  }
}

class UserWorkoutWeek{
  late List<UserWorkoutDay> days;

  UserWorkoutWeek(this.days);

  Map<String, dynamic> toMap() {
    return {
      "days": days.map((w) => w.toMap()).toList(),
    };
  }

  UserWorkoutWeek.fromJson(Map<String, dynamic> value){
    days = (value['days'] as List).map((w) => UserWorkoutDay.fromJson(w)).toList();
  }
}

class UserWorkoutDay{
  late int completedOnMs;

  UserWorkoutDay.empty();

  UserWorkoutDay.fromJson(Map<String, dynamic> value){
    completedOnMs = value['completedOnMs'];
  }

  Map<String, dynamic> toMap() {
    return {
      "completedOnMs": completedOnMs,
    };
  }
}