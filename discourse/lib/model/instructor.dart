import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/root_model.dart';

/// Model class to represent an instructor
class Instructor extends RootModel {
  Instructor(
      {this.instructorId,
      required this.firstName,
      required this.lastName,
      this.externalRating,
      this.externalUrl,
      this.averageCourseRating,
      this.courseReviewsForInstructor,
      this.averageDifficultyRating});

  String? instructorId;
  final String firstName;
  final String lastName;
  String? externalUrl;
  double? externalRating;
  double? averageCourseRating;
  double? averageDifficultyRating;
  List<IndividualCourseReview>? courseReviewsForInstructor;

  @override
  String getLabel() {
    return '$firstName $lastName';
  }

  @override
  String getKey() {
    return '$firstName $lastName';
  }

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'first_name': firstName,
      'course_number': lastName,
    };
  }

  factory Instructor.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    double rating = 0;
    if (data!['external_rating'] is int) {
      rating = data['external_rating'].toDouble();
    } else {
      rating = data['external_rating'];
    }
    return Instructor(
        instructorId: snapshot.reference.id,
        firstName: data['first_name'],
        lastName: data['last_name'],
        externalUrl: data['external_url'],
        externalRating: rating);
  }

  // Create a Course instance from Firestore DocumentSnapshot
  factory Instructor.fromDocument(Map<String, dynamic> doc) {
    double rating = 0;
    if (doc['external_rating'] is int) {
      rating = doc['external_rating'].toDouble();
    } else {
      rating = doc['external_rating'];
    }
    return Instructor(
        instructorId: doc['id'],
        firstName: doc['first_name'],
        lastName: doc['last_name'],
        externalUrl: doc['external_url'],
        externalRating: rating);
  }

  factory Instructor.fromJson(Map<String, dynamic> data) {
    return Instructor(
        instructorId: data['id'],
        firstName: data['first_name'],
        lastName: data['last_name']);
  }
}
