import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';

/// Model class to represent a Course Review
class CourseReview{
  CourseReview({
    this.courseReviewId,
    required this.courseId,
    this.course,
    this.instructor,
    required this.instructorId,
    required this.averageOverallRating,
    required this.averageDifficultyRating,
    required this.tags,
    required this.workloadFrequency,
    required this.gradeFrequency,
    this.individualCourseReviews,
    this.workloadFrequencyData,
    this.gradeFrequencyData,
  });

  String? courseReviewId;
  final String courseId;
  final String instructorId;
  Course? course;
  Instructor? instructor;
  double averageOverallRating;
  double averageDifficultyRating;
  final List<String> tags;
  final Map<String, int> workloadFrequency;
  final Map<String, int> gradeFrequency;
  List<IndividualCourseReview>? individualCourseReviews;
  List<Map<String, int>>? workloadFrequencyData;
  List<Map<String, int>>? gradeFrequencyData;
  
  Map<String, dynamic> toFirestore() {
    List<Map<String, dynamic>> individualReviewsToFirestore = [];

    for (var review in individualCourseReviews!) {
      individualReviewsToFirestore.add(review.toFirestore());
    }

    return {
      'course_id': courseId,
      'instructor_id': instructorId,
      'average_overall_rating': averageOverallRating,
      'average_difficulty_rating': averageDifficultyRating,
      'tags': tags,
      'workload_frequency': workloadFrequency,
      'grade_frequency': gradeFrequency,
      'individual_course_reviews': individualReviewsToFirestore,
    };
  }

  factory CourseReview.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    List<IndividualCourseReview> indivReviews = [];
    List<Map<String, int>> tempWorkloadFrequencyData = [];
    List<Map<String, int>> tempGradeFrequencyData = [];

    data?['individual_course_reviews'].forEach((entry) {
      indivReviews.add(IndividualCourseReview.fromDocument(entry));
    });

    data?['workload_frequency'].forEach((key, value) {
      tempWorkloadFrequencyData.add({key: value});
    });

    data?['grade_frequency'].forEach((key, value) {
      tempGradeFrequencyData.add({key: value});
    });

    return CourseReview(
      courseReviewId: snapshot.reference.id,
      courseId: data?['course_id'],
      instructorId: data?['instructor_id'],
      averageOverallRating: data?['average_overall_rating'],
      averageDifficultyRating: data?['average_difficulty_rating'],
      tags: List<String>.from(data?['tags']),
      workloadFrequency: Map<String, int>.from(data?['workload_frequency']),
      gradeFrequency: Map<String, int>.from(data?['grade_frequency']),
      individualCourseReviews: indivReviews,
      workloadFrequencyData: tempWorkloadFrequencyData,
      gradeFrequencyData: tempGradeFrequencyData,
    );
  }
}
