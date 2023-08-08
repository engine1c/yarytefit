import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yarytefit/domain/workout.dart';

class DatabaseService{
  final CollectionReference _workoutCollection = FirebaseFirestore.instance.collection('workouts');
  final CollectionReference _workoutScheduleCollection = FirebaseFirestore.instance.collection('workoutSchedules');

  Future addOrUpdateWorkout(WorkoutSchedule schedule) async {
     if (schedule.uid.isNotEmpty) {
    DocumentReference workoutRef = _workoutCollection.doc(schedule.uid);

    return workoutRef.set(schedule.toWorkoutMap()).then((_) async{
      var docId = workoutRef.id;
      await _workoutScheduleCollection.doc(docId).set(schedule.toMap());
    });
      } else {
    throw Exception("schedule.uid is empty or null");
  }
  }

  Stream<List<Workout>> getWorkouts({required String level, required String author})
  {
    Query query;
    if(author != null) {
      query = _workoutCollection.where('author', isEqualTo: author);
    } else {
      query = _workoutCollection.where('isOnline', isEqualTo: true);
    }

    query = query.where('level', isEqualTo: level);

      //query = query.orderBy('createdOn', descending: true);

    return query.snapshots().map((QuerySnapshot data) =>
        data.docs.map((DocumentSnapshot doc) => 
        Workout.fromJson(doc.data as Map<String, dynamic>, id: doc.id)).toList());
  }

  Future<WorkoutSchedule> getWorkout(String id) async{
    var doc = await _workoutScheduleCollection.doc(id).get();
    return 
    WorkoutSchedule.fromJson(doc.id, doc.data as Map<String, dynamic>);
  }
}