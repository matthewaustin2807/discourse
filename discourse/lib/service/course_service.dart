import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/service/service.dart';

/// Course service to handle grabbing Course data from Firestore
class CourseService extends Service {
  CourseService();

  final CollectionReference _courseCollection =
      FirebaseFirestore.instance.collection('courses');

  /// Add a new course to Firestore
  Future<void> addCourse(Course course) async {
    await _courseCollection.add(course.toMap());
  }

  /// Get a course by its document ID
  Future<Course?> getCourse(String courseId) async {
    DocumentSnapshot doc = await _courseCollection.doc(courseId).get();

    if (doc.exists) {
      return Course.fromDocument(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Gets all Course from Firestore
  Future<List<Course>> getAllCourse() async {
    List<Course> result = [];
    final ref = _courseCollection
        .withConverter(
            fromFirestore: Course.fromFirestore,
            toFirestore: (Course course, _) => course.toFirestore());
    await ref.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          result.add(docSnapshot.data());
        }
      }
    ); 
    return result;
  }

  /// Gets all course filtered by its course name from Firestore
  Future<List<Course>> getAllCourseFiltered(String courseName) async {
    List<Course> result = [];
    final ref = _courseCollection
        .withConverter(
            fromFirestore: Course.fromFirestore,
            toFirestore: (Course course, _) => course.toFirestore());
    await ref.where('course_name', isEqualTo: courseName).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          result.add(docSnapshot.data());
        }
      }
    ); 
    return result;
  }

  /// Update a course's information
  Future<void> updateCourse(
      String courseId, Map<String, dynamic> updatedData) async {
    await _courseCollection.doc(courseId).update(updatedData);
  }

  /// Delete a course by its document ID
  Future<void> deleteCourse(String courseId) async {
    await _courseCollection.doc(courseId).delete();
  }

  /// Get all courses by a specific instructor
  Future<List<Course>> getCoursesByInstructor(String instructorId) async {
    QuerySnapshot querySnapshot = await _courseCollection
        .where('instructorId', isEqualTo: instructorId)
        .get();

    return querySnapshot.docs
        .map((doc) => Course.fromDocument(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get all courses with a specific tag
  Future<List<Course>> getCoursesWithTag(String tag) async {
    QuerySnapshot querySnapshot =
        await _courseCollection.where('tags', arrayContains: tag).get();

    return querySnapshot.docs
        .map((doc) => Course.fromDocument(doc.data() as Map<String, dynamic>))
        .toList();
  }
}