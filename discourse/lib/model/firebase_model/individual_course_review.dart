import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/instructor.dart';

/// Model class to represent an individual course review
class IndividualCourseReview {
  IndividualCourseReview({
    required this.reviewerId,
    required this.reviewerUsername,
    required this.courseId,
    this.course,
    this.instructor,
    required this.instructorId,
    required this.semester,
    required this.year,
    required this.tags,
    required this.estimatedWorkload,
    required this.grade,
    required this.difficultyRating,
    required this.overallRating,
    required this.reviewDetail,
  });

  String? individualCourseReviewId;
  final String reviewerId;
  final String reviewerUsername;
  final String courseId;
  Course? course;
  final String instructorId;
  Instructor? instructor;
  final String semester;
  final String year;
  final String estimatedWorkload;
  final String grade;
  final double difficultyRating;
  final double overallRating;
  final String reviewDetail;
  final List<String> tags;

  Map<String, dynamic> toFirestore() {
    return {
      'reviewer_id': reviewerId,
      'reviewer_username': reviewerUsername,
      'course_id': courseId,
      'instructor_id': instructorId,
      'semester': semester,
      'year': year,
      'tags': tags,
      'grade': grade,
      'workload': estimatedWorkload,
      'difficulty_rating': difficultyRating,
      'overall_rating': overallRating,
      'review_detail': reviewDetail
    };
  }

  // Create a Course instance from Firestore DocumentSnapshot
  factory IndividualCourseReview.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return IndividualCourseReview(
        reviewerId: data?['reviewer_id'],
        reviewerUsername: data?['reviewer_username'],
        courseId: data?['course_id'],
        instructorId: data?['instructor_id'],
        semester: data?['semester'],
        year: data?['year'],
        tags: data?['tags'],
        estimatedWorkload: data?['workload'],
        grade: data?['grade'],
        difficultyRating: data?['difficulty_rating'],
        overallRating: data?['overall_rating'],
        reviewDetail: data?['review_detail']);
  }

  factory IndividualCourseReview.fromDocument(Map<String, dynamic> data) {
    return IndividualCourseReview(
        reviewerId: data['reviewer_id'],
        reviewerUsername: data['reviewer_username'],
        courseId: data['course_id'],
        instructorId: data['instructor_id'],
        semester: data['semester'],
        year: data['year'],
        tags: List<String>.from(data['tags']),
        estimatedWorkload: data['workload'],
        grade: data['grade'],
        difficultyRating: data['difficulty_rating'],
        overallRating: data['overall_rating'],
        reviewDetail: data['review_detail']);
  }
}
