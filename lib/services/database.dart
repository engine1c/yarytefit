import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yarytefit/domain/workout.dart';

class DatabaseService{
  final CollectionReference _workoutCollection = FirebaseFirestore.instance.collection('workouts');
  final CollectionReference _workoutScheduleCollection = FirebaseFirestore.instance.collection('workoutSchedules');

  Future addOrUpdateWorkout(WorkoutSchedule schedule) async {
   
  if (schedule.uid.isEmpty) {
    // Если UID пустой, генерируем новый уникальный ID
    schedule.uid = _workoutCollection.doc().id;}

    DocumentReference workoutRef = _workoutCollection.doc(schedule.uid);

    return workoutRef.set(schedule.toWorkoutMap()).then((_) async{
      var docId = workoutRef.id;
      await _workoutScheduleCollection.doc(docId).set(schedule.toMap());
    });
  //    if (schedule.uid.isNotEmpty) {   } else {
  //   throw Exception("schedule.uid is empty or null");
  // }
   }

  Stream<List<Workout>> getWorkouts({required String level, required String author})
  {
    Query query;
    if(author != '') {
      query = _workoutCollection.where('author', isEqualTo: author);
    } else {
      query = _workoutCollection.where('isOnline', isEqualTo: true);
    }
if(level != '') {
  query = query.where('level', isEqualTo: level);
}

// print('Query:${query.parameters.values.map((e) => e)}');
// print('level:${(level)}-');
// print('author:${author.toString()}-');
//query = query.orderBy('isOnline', descending: true);

return query.snapshots().map((QuerySnapshot data) {
  print('Number of documents: ${data.docs.length}');
  return data.docs.map((DocumentSnapshot doc) {
    final id = doc.id;
    final data = doc.data() as Map<String, dynamic>;
    return Workout.fromJson(id, data);
  }).toList();
});

  }

  Future<WorkoutSchedule> getWorkout(String id) async{
    var doc = await _workoutScheduleCollection.doc(id).get();
    return 
    WorkoutSchedule.fromJson(doc.id, doc.data() as Map<String, dynamic>);
  }
}