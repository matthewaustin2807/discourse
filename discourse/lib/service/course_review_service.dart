import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/bookmark.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/service/bookmark_service.dart';
import 'package:discourse/service/course_service.dart';
import 'package:discourse/service/instructor_service.dart';
import 'package:discourse/service/service.dart';

/// Course Review service to handle grabbing Course Review data from Firestore
class CourseReviewService extends Service {
  final CollectionReference _courseReviewCollection =
      FirebaseFirestore.instance.collection('course_reviews');

  /// Add a new course to Firestore
  Future<void> addCourseReview(IndividualCourseReview review) async {
    var ref = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview courseReview, _) =>
            courseReview.toFirestore());

    await ref
        .where('course_id', isEqualTo: review.courseId)
        .where('instructor_id', isEqualTo: review.instructorId)
        .get()
        .then((querySnapshot) {
      // If there is no course review with the same instructor and course, create a new entry
      if (querySnapshot.docs.isEmpty) {
        Map<String, int> workloadFrequency = {review.estimatedWorkload: 1};
        Map<String, int> gradeFrequency = {review.grade: 1};

        CourseReview newReview = CourseReview(
            courseId: review.courseId,
            instructorId: review.instructorId,
            averageOverallRating: review.overallRating,
            averageDifficultyRating: review.difficultyRating,
            tags: review.tags,
            workloadFrequency: workloadFrequency,
            gradeFrequency: gradeFrequency,
            individualCourseReviews: List.filled(1, review));

        ref.add(newReview);
      } else {
        // If there exists a course review with the same instructor and course, add this individual review into this document.
        var courseReview = querySnapshot.docs[0].data();

        // Update the difficulty rating and overall rating
        courseReview.averageDifficultyRating =
            (courseReview.averageDifficultyRating + review.difficultyRating) /
                (courseReview.individualCourseReviews!.length + 1);
        courseReview.averageOverallRating =
            (courseReview.averageOverallRating + review.overallRating) /
                (courseReview.individualCourseReviews!.length + 1);

        // Add tags only if they are not already present
        for (var tag in review.tags) {
          if (!courseReview.tags.contains(tag)) {
            courseReview.tags.add(tag);
          }
        }

        // Increment the frequency of workload
        if (courseReview.workloadFrequency
            .containsKey(review.estimatedWorkload)) {
          courseReview.workloadFrequency[review.estimatedWorkload] =
              courseReview.workloadFrequency[review.estimatedWorkload]! + 1;
        } else {
          courseReview.workloadFrequency[review.estimatedWorkload] = 1;
        }

        // Increment the frequency of grade received
        if (courseReview.gradeFrequency.containsKey(review.grade)) {
          courseReview.gradeFrequency[review.grade] =
              courseReview.gradeFrequency[review.grade]! + 1;
        } else {
          courseReview.gradeFrequency[review.grade] = 1;
        }

        // Add this individual review to the document as well.
        courseReview.individualCourseReviews!.add(review);

        ref.doc(courseReview.courseReviewId).set(courseReview);
      }
    });
    // await _courseReviewCollection.add(course.toFirestore());
  }

  /// Get all course reviews
  Future<List<CourseReview>> getAllCoursesForDigest() async {
    List<CourseReview> courseReviews = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());

    await courseReviewRef.get().then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        CourseReview review = doc.data();
        review.course = await CourseService().getCourse(doc.data().courseId);
        review.instructor =
            await InstructorService().getInstructor(doc.data().instructorId);
        courseReviews.add(review);
      }
    });
    return courseReviews;
  }

  /// Get all course reviews except a specified one
  Future<List<CourseReview>> getAllCoursesForComparison(
      String courseReviewId) async {
    List<CourseReview> courseReviews = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());

    await courseReviewRef.get().then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        if (doc.reference.id == courseReviewId) continue;
        CourseReview review = doc.data();
        review.course = await CourseService().getCourse(doc.data().courseId);
        review.instructor =
            await InstructorService().getInstructor(doc.data().instructorId);
        courseReviews.add(review);
      }
    });
    return courseReviews;
  }

  /// Get all course reviews filtered by course name
  Future<List<CourseReview>> getAllCoursesFilteredByCourse(String courseName,
      {bool forCompare = false, String? currentCourseReviewId}) async {
    List<CourseReview> filteredReviews = [];

    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());

    List<Course> filteredCourses =
        await CourseService().getAllCourseFiltered(courseName);

    if (forCompare) {
      await courseReviewRef
          .where('course_id',
              whereIn: [for (Course course in filteredCourses) course.courseId])
          .get()
          .then((reviewSnapshot) async {
            for (var review in reviewSnapshot.docs) {
              if (review.reference.id == currentCourseReviewId!) continue;
              CourseReview queriedReview = review.data();
              queriedReview.course =
                  await CourseService().getCourse(queriedReview.courseId);
              queriedReview.instructor = await InstructorService()
                  .getInstructor(queriedReview.instructorId);
              filteredReviews.add(queriedReview);
            }
            return filteredReviews;
          });
    } else {
      await courseReviewRef
          .where('course_id',
              whereIn: [for (Course course in filteredCourses) course.courseId])
          .get()
          .then((reviewSnapshot) async {
            for (var review in reviewSnapshot.docs) {
              CourseReview queriedReview = review.data();
              queriedReview.course =
                  await CourseService().getCourse(queriedReview.courseId);
              queriedReview.instructor = await InstructorService()
                  .getInstructor(queriedReview.instructorId);
              filteredReviews.add(queriedReview);
            }
            return filteredReviews;
          });
    }

    return filteredReviews;
  }

  /// Gets all course reviews filtered by instructor name
  Future<List<CourseReview>> getAllCoursesFilteredByInstructor(
      String instructorName,
      {bool forCompare = false,
      String? currentCourseReviewId}) async {
    List<CourseReview> filteredReviews = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());

    List<Instructor> filteredInstructors =
        await InstructorService().getAllInstructorFiltered(instructorName);

    if (forCompare) {
      await courseReviewRef
          .where('instructor_id', whereIn: [
            for (Instructor instructor in filteredInstructors)
              instructor.instructorId
          ])
          .get()
          .then((reviewSnapshot) async {
            for (var review in reviewSnapshot.docs) {
              if (review.reference.id == currentCourseReviewId!) continue;
              CourseReview queriedReview = review.data();
              queriedReview.course =
                  await CourseService().getCourse(queriedReview.courseId);
              queriedReview.instructor = await InstructorService()
                  .getInstructor(queriedReview.instructorId);
              filteredReviews.add(queriedReview);
            }
            return filteredReviews;
          });
    } else {
      await courseReviewRef
          .where('instructor_id', whereIn: [
            for (Instructor instructor in filteredInstructors)
              instructor.instructorId
          ])
          .get()
          .then((reviewSnapshot) async {
            for (var review in reviewSnapshot.docs) {
              CourseReview queriedReview = review.data();
              queriedReview.course =
                  await CourseService().getCourse(queriedReview.courseId);
              queriedReview.instructor = await InstructorService()
                  .getInstructor(queriedReview.instructorId);
              filteredReviews.add(queriedReview);
            }
            return filteredReviews;
          });
    }
    return filteredReviews;
  }

  /// Gets all Course Review names that exists in Firestore
  Future<List<Course>> getAllExistingReviews() async {
    List<Course> allExistingCourses = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());

    await courseReviewRef.get().then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        Course course =
            await CourseService().getCourse(doc.data().courseId) as Course;
        if (!allExistingCourses.contains(course)) {
          allExistingCourses.add(course);
        }
      }
    });
    return allExistingCourses;
  }

  /// Gets all Existing My Reviews from Firestore
  Future<List<Course>> getAllExistingMyReviews(String userId) async {
    List<Course> allExistingMyReviewCourses = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());
    await courseReviewRef.get().then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        for (var review in doc.data().individualCourseReviews!) {
          if (review.reviewerId == userId) {
            Course? course = await CourseService().getCourse(review.courseId);
            if (!allExistingMyReviewCourses.contains(course!)) {
              allExistingMyReviewCourses.add(course);
            }
          }
        }
      }
    });
    return allExistingMyReviewCourses;
  }

  /// Gets all My Reviews filtered by Course Name from Firestore
  Future<List<IndividualCourseReview>> getMyReviewsFiltered(
      String courseName, String userId) async {
    List<IndividualCourseReview> myReviews = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());

    List<Course> filteredCourses =
        await CourseService().getAllCourseFiltered(courseName);

    await courseReviewRef
        .where('course_id',
            whereIn: [for (Course course in filteredCourses) course.courseId])
        .get()
        .then((querySnapshot) async {
          for (var doc in querySnapshot.docs) {
            for (var review in doc.data().individualCourseReviews!) {
              if (review.reviewerId == userId) {
                review.course =
                    await CourseService().getCourse(review.courseId);
                review.instructor = await InstructorService()
                    .getInstructor(review.instructorId);
                myReviews.add(review);
              }
            }
          }
        });
    return myReviews;
  }

  /// Gets all My Reviews from Firestroe
  Future<List<IndividualCourseReview>> getMyReviews(String userId) async {
    List<IndividualCourseReview> myReviews = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());

    await courseReviewRef.get().then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        for (var review in doc.data().individualCourseReviews!) {
          if (review.reviewerId == userId) {
            review.course = await CourseService().getCourse(review.courseId);
            review.instructor =
                await InstructorService().getInstructor(review.instructorId);
            myReviews.add(review);
          }
        }
      }
    });
    return myReviews;
  }

  /// Gets all My Bookmarked course reviews from Firestore
  Future<List<CourseReview>> getMyBookmarks(String userId) async {
    List<CourseReview> myBookmarks = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());

    List<Bookmark> bookmarks =
        await BookmarkService().getBookmarksByUser(userId);

    for (Bookmark bookmark in bookmarks) {
      await courseReviewRef.doc(bookmark.courseId).get().then((doc) async {
        CourseReview review = doc.data()!;
        review.course = await CourseService().getCourse(review.courseId);
        review.instructor =
            await InstructorService().getInstructor(review.instructorId);
        myBookmarks.add(review);
      });
    }

    return myBookmarks;
  }

  /// Gets all Course Names that are bookmarked by the current user
  Future<List<Course>> getAllCourseNamesFromMyBookmarks(String userId) async {
    List<Course> courses = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());
    List<Bookmark> bookmarks =
        await BookmarkService().getBookmarksByUser(userId);

    for (Bookmark bookmark in bookmarks) {
      await courseReviewRef.doc(bookmark.courseId).get().then((doc) async {
        CourseReview review = doc.data()!;
        Course? course = await CourseService().getCourse(review.courseId);
        courses.add(course!);
      });
    }
    return courses;
  }

/// Gets all Course Names that are bookmarked by the current user filtered by Course Name
  Future<List<CourseReview>> getMyBookmarksFilteredByCourse(
      String userId, String courseName) async {
    List<CourseReview> myBookmarks = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());

    List<Bookmark> bookmarks =
        await BookmarkService().getBookmarksByUser(userId);

    for (Bookmark bookmark in bookmarks) {
      await courseReviewRef.doc(bookmark.courseId).get().then((doc) async {
        CourseReview review = doc.data()!;
        review.course = await CourseService().getCourse(review.courseId);
        if (review.course!.courseName == courseName) {
          review.instructor =
              await InstructorService().getInstructor(review.instructorId);
          myBookmarks.add(review);
        }
      });
    }
    return myBookmarks;
  }

  /// Gets all Course Review available in Firestore given the Instructor name
  Future<List<IndividualCourseReview>>
      getAllIndividualCourseReviewForInstructor(String instructorId) async {
    List<IndividualCourseReview> individualCourseReviews = [];
    final courseReviewRef = _courseReviewCollection.withConverter(
        fromFirestore: CourseReview.fromFirestore,
        toFirestore: (CourseReview review, _) => review.toFirestore());

    await courseReviewRef
        .where('instructor_id', isEqualTo: instructorId)
        .get()
        .then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        for (IndividualCourseReview review
            in doc.data().individualCourseReviews!) {
          Course? course = await CourseService().getCourse(review.courseId);
          IndividualCourseReview tempReview = IndividualCourseReview(
              reviewerId: review.reviewerId,
              reviewerUsername: review.reviewerUsername,
              courseId: review.courseId,
              course: course,
              instructorId: review.instructorId,
              semester: review.semester,
              year: review.year,
              tags: review.tags,
              estimatedWorkload: review.estimatedWorkload,
              grade: review.grade,
              difficultyRating: review.difficultyRating,
              overallRating: review.overallRating,
              reviewDetail: review.reviewDetail);
          individualCourseReviews.add(tempReview);
        }
      }
    });
    return individualCourseReviews;
  }
}
