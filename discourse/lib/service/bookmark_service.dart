import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/bookmark.dart';
import 'package:discourse/service/course_service.dart';
import 'package:discourse/service/service.dart';
import 'package:discourse/service/user_service.dart';

/// Bookmark service to handle grabbing Bookmark data from Firestore
class BookmarkService extends Service {
  final CollectionReference _bookmarkCollection =
      FirebaseFirestore.instance.collection('bookmarks');

  /// Add a new bookmark to Firestore
  Future<void> addBookmark(Bookmark bookmark) async {
    await _bookmarkCollection.add(bookmark.toMap());
  }

  /// Gets all Bookmarked courses from Firestore
  Future<List<Course>> getBookmarkedCourses() async {
    // Step 1: Get the current user's ID
    UserService userService = UserService();
    String? userId = await userService.getCurrentUserUid();

    // Step 2: Get the user's bookmarks
    QuerySnapshot querySnapshot =
        await _bookmarkCollection.where('userId', isEqualTo: userId).get();

    List<Bookmark> bookmarks = querySnapshot.docs
        .map((doc) => Bookmark.fromDocument(doc.data() as Map<String, dynamic>))
        .toList();

    // Step 3: Fetch courses for each bookmarked courseId
    CourseService courseService = CourseService();
    List<Course> courses = [];
    for (Bookmark bookmark in bookmarks) {
      Course? course = await courseService.getCourse(bookmark.courseId);
      if (course != null) {
        courses.add(course);
      }
    }

    return courses;
  }

  /// Get all bookmarks for a specific user
  Future<List<Bookmark>> getBookmarksByUser(String userId) async {
    QuerySnapshot querySnapshot =
        await _bookmarkCollection.where('userId', isEqualTo: userId).get();

    return querySnapshot.docs
        .map((doc) => Bookmark.fromDocument(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Delete a bookmark by user ID and course ID
  Future<void> deleteBookmark(String userId, String courseId) async {
    QuerySnapshot querySnapshot = await _bookmarkCollection
        .where('userId', isEqualTo: userId)
        .where('courseId', isEqualTo: courseId)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Check if a bookmark exists for a specific user and course
  Future<bool> isBookmarked(String userId, String courseId) async {
    QuerySnapshot querySnapshot = await _bookmarkCollection
        .where('userId', isEqualTo: userId)
        .where('courseId', isEqualTo: courseId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
