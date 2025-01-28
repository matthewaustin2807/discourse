import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/root_model.dart';

/// Model class to represent a course.
class Course extends RootModel {
  Course(
      {this.courseId,
      required this.courseName,
      required this.courseNumber,
      required this.courseDescription,
      this.externalUrl,
      this.externalRating});

  String? courseId;
  final String courseName;
  final String courseNumber;
  final String courseDescription;
  String? externalUrl;
  double? externalRating;

  @override
  bool operator ==(Object other) {
    if (other is Course) {
      return other.courseName == courseName && other.courseId == courseId;
    } else {
      return false;
    }
  }

  @override
  String getLabel() {
    return '$courseNumber: $courseName';
  }

  @override
  String getKey() {
    return courseName;
  }

  Map<String, dynamic> toMap() {
    return {
      'course_name': courseName,
      'course_number': courseNumber,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'course_name': courseName,
      'course_number': courseNumber,
      'course_description': courseDescription
    };
  }

  factory Course.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    double rating = 0;

    if (data!['external_rating'] is int) {
      rating = data['external_rating'].toDouble();
    } else {
      rating = data['external_rating'];
    }

    return Course(
        courseId: snapshot.reference.id,
        courseName: data['course_name'],
        courseNumber: data['course_number'],
        courseDescription: data['course_description'],
        externalRating: rating,
        externalUrl: data['external_url']);
  }

  // Create a Course instance from Firestore DocumentSnapshot
  factory Course.fromDocument(Map<String, dynamic> doc) {
    double rating = 0;

    if (doc['external_rating'] is int) {
      rating = doc['external_rating'].toDouble();
    } else {
      rating = doc['external_rating'];
    }
    return Course(
        courseId: doc['id'],
        courseName: doc['course_name'],
        courseNumber: doc['course_number'],
        courseDescription: doc['course_description'],
        externalRating: rating,
        externalUrl: doc['external_url']);
  }
}
