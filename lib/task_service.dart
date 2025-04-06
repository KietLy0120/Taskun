import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //CRUD Operations
  Future<void> addTask(String title, String description, String type, String category, String priority, String status, DateTime deadline) async {
    await _db.collection('tasks').add({
      'title': title,
      'description': description,
      'type': type,
      'category': category,
      'priority': priority,
      'status': status,
      'deadline': deadline.toIso8601String(),
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getTasks() {
    return _db.collection('tasks').orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> updatedData) async {
    await _db.collection('tasks').doc(taskId).update(updatedData);
  }

  Future<void> deleteTask(String taskId) async {
    await _db.collection('tasks').doc(taskId).delete();
  }
}
