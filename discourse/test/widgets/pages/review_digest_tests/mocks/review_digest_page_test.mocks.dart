// Mocks generated by Mockito 5.4.4 from annotations
// in discourse/test/widgets/pages/review_digest_tests/review_digest_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:discourse/model/course.dart' as _i6;
import 'package:discourse/model/firebase_model/course_review.dart' as _i5;
import 'package:discourse/model/firebase_model/individual_course_review.dart'
    as _i4;
import 'package:discourse/service/course_review_service.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [CourseReviewService].
///
/// See the documentation for Mockito's code generation for more information.
class MockCourseReviewService extends _i1.Mock
    implements _i2.CourseReviewService {
  MockCourseReviewService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> addCourseReview(_i4.IndividualCourseReview? review) =>
      (super.noSuchMethod(
        Invocation.method(
          #addCourseReview,
          [review],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<_i5.CourseReview>> getAllCoursesForDigest() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllCoursesForDigest,
          [],
        ),
        returnValue:
            _i3.Future<List<_i5.CourseReview>>.value(<_i5.CourseReview>[]),
      ) as _i3.Future<List<_i5.CourseReview>>);

  @override
  _i3.Future<List<_i5.CourseReview>> getAllCoursesForComparison(
          String? courseReviewId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllCoursesForComparison,
          [courseReviewId],
        ),
        returnValue:
            _i3.Future<List<_i5.CourseReview>>.value(<_i5.CourseReview>[]),
      ) as _i3.Future<List<_i5.CourseReview>>);

  @override
  _i3.Future<List<_i5.CourseReview>> getAllCoursesFilteredByCourse(
    String? courseName, {
    bool? forCompare = false,
    String? currentCourseReviewId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllCoursesFilteredByCourse,
          [courseName],
          {
            #forCompare: forCompare,
            #currentCourseReviewId: currentCourseReviewId,
          },
        ),
        returnValue:
            _i3.Future<List<_i5.CourseReview>>.value(<_i5.CourseReview>[]),
      ) as _i3.Future<List<_i5.CourseReview>>);

  @override
  _i3.Future<List<_i5.CourseReview>> getAllCoursesFilteredByInstructor(
    String? instructorName, {
    bool? forCompare = false,
    String? currentCourseReviewId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllCoursesFilteredByInstructor,
          [instructorName],
          {
            #forCompare: forCompare,
            #currentCourseReviewId: currentCourseReviewId,
          },
        ),
        returnValue:
            _i3.Future<List<_i5.CourseReview>>.value(<_i5.CourseReview>[]),
      ) as _i3.Future<List<_i5.CourseReview>>);

  @override
  _i3.Future<List<_i6.Course>> getAllExistingReviews() => (super.noSuchMethod(
        Invocation.method(
          #getAllExistingReviews,
          [],
        ),
        returnValue: _i3.Future<List<_i6.Course>>.value(<_i6.Course>[]),
      ) as _i3.Future<List<_i6.Course>>);

  @override
  _i3.Future<List<_i6.Course>> getAllExistingMyReviews(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllExistingMyReviews,
          [userId],
        ),
        returnValue: _i3.Future<List<_i6.Course>>.value(<_i6.Course>[]),
      ) as _i3.Future<List<_i6.Course>>);

  @override
  _i3.Future<List<_i4.IndividualCourseReview>> getMyReviewsFiltered(
    String? courseName,
    String? userId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMyReviewsFiltered,
          [
            courseName,
            userId,
          ],
        ),
        returnValue: _i3.Future<List<_i4.IndividualCourseReview>>.value(
            <_i4.IndividualCourseReview>[]),
      ) as _i3.Future<List<_i4.IndividualCourseReview>>);

  @override
  _i3.Future<List<_i4.IndividualCourseReview>> getMyReviews(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMyReviews,
          [userId],
        ),
        returnValue: _i3.Future<List<_i4.IndividualCourseReview>>.value(
            <_i4.IndividualCourseReview>[]),
      ) as _i3.Future<List<_i4.IndividualCourseReview>>);

  @override
  _i3.Future<List<_i5.CourseReview>> getMyBookmarks(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMyBookmarks,
          [userId],
        ),
        returnValue:
            _i3.Future<List<_i5.CourseReview>>.value(<_i5.CourseReview>[]),
      ) as _i3.Future<List<_i5.CourseReview>>);

  @override
  _i3.Future<List<_i6.Course>> getAllCourseNamesFromMyBookmarks(
          String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllCourseNamesFromMyBookmarks,
          [userId],
        ),
        returnValue: _i3.Future<List<_i6.Course>>.value(<_i6.Course>[]),
      ) as _i3.Future<List<_i6.Course>>);

  @override
  _i3.Future<List<_i5.CourseReview>> getMyBookmarksFilteredByCourse(
    String? userId,
    String? courseName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMyBookmarksFilteredByCourse,
          [
            userId,
            courseName,
          ],
        ),
        returnValue:
            _i3.Future<List<_i5.CourseReview>>.value(<_i5.CourseReview>[]),
      ) as _i3.Future<List<_i5.CourseReview>>);

  @override
  _i3.Future<List<_i4.IndividualCourseReview>>
      getAllIndividualCourseReviewForInstructor(String? instructorId) =>
          (super.noSuchMethod(
            Invocation.method(
              #getAllIndividualCourseReviewForInstructor,
              [instructorId],
            ),
            returnValue: _i3.Future<List<_i4.IndividualCourseReview>>.value(
                <_i4.IndividualCourseReview>[]),
          ) as _i3.Future<List<_i4.IndividualCourseReview>>);
}
