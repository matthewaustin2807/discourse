import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/service/course_review_service.dart';
import 'package:discourse/service/service.dart';

/// Instructor Service class to handle grabbing Instructor data from Firestore
class InstructorService extends Service {
  final CollectionReference _instructorsCollection =
      FirebaseFirestore.instance.collection('instructors');

  /// Add a new instructor to Firestore
  Future<void> addInstructor(Instructor instructor) async {
    await _instructorsCollection.add(instructor.toMap());
  }

  /// Get an instructor by their document ID
  Future<Instructor?> getInstructor(String instructorId) async {
    DocumentSnapshot doc = await _instructorsCollection.doc(instructorId).get();

    if (doc.exists) {
      return Instructor.fromDocument(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Get all instructors
  Future<List<Instructor>> getAllInstructors() async {
    List<Instructor> result = [];
    final ref = _instructorsCollection.withConverter(
        fromFirestore: Instructor.fromFirestore,
        toFirestore: (Instructor instructor, _) => instructor.toFirestore());
    await ref.get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        result.add(docSnapshot.data());
      }
    });
    return result;
  }

  /// Get all instructors filtered by the name
  Future<List<Instructor>> getAllInstructorFiltered(
      String instructorName) async {
    List<String> splitName = instructorName.split(' ');

    List<Instructor> result = [];
    final ref = _instructorsCollection.withConverter(
        fromFirestore: Instructor.fromFirestore,
        toFirestore: (Instructor instructor, _) => instructor.toFirestore());
    await ref
        .where('first_name', isEqualTo: splitName[0])
        .where('last_name', isEqualTo: splitName[1])
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        result.add(docSnapshot.data());
      }
    });
    return result;
  }

  /// Update an existing instructor
  Future<void> updateInstructor(
      String instructorId, Map<String, dynamic> updatedData) async {
    await _instructorsCollection.doc(instructorId).update(updatedData);
  }

  /// Delete an instructor by their document ID
  Future<void> deleteInstructor(String instructorId) async {
    await _instructorsCollection.doc(instructorId).delete();
  }

  /// Get instructor details given its instructor id
  Future<Instructor?> getInstructorDetails(String instructorId) async {
    Instructor? instructor = await getInstructor(instructorId);
    if (instructor != null) {
      String firstName = instructor.firstName;
      String lastName = instructor.lastName;

      double averageCourseRating = 0;
      double averageDifficultyRating = 0;
      List<CourseReview> instructorCourses = await CourseReviewService()
          .getAllCoursesFilteredByInstructor('$firstName $lastName');
      for (CourseReview course in instructorCourses) {
        averageCourseRating += course.averageOverallRating;
        averageDifficultyRating += course.averageDifficultyRating;
      }
      averageCourseRating /= instructorCourses.length;
      averageDifficultyRating /= instructorCourses.length;

      List<IndividualCourseReview> individualReviews =
          await CourseReviewService()
              .getAllIndividualCourseReviewForInstructor(instructorId);
      
      return Instructor(
        firstName: firstName,
        lastName: lastName,
        externalRating: instructor.externalRating!,
        externalUrl: instructor.externalUrl,
        averageCourseRating: averageCourseRating,
        averageDifficultyRating: averageDifficultyRating,
        courseReviewsForInstructor: individualReviews,
      );
    } else {
      return null;
    }
  }
}
