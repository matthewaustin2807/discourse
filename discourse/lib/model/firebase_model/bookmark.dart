/// Model class to represent a Bookmark in Firestore
class Bookmark {
  Bookmark({
    required this.courseId,
    required this.userId,
  });

  final String courseId;
  final String userId;

  // Convert a Bookmark instance into a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'userId': userId,
    };
  }

  // Create a Bookmark instance from Firestore DocumentSnapshot
  factory Bookmark.fromDocument(Map<String, dynamic> doc) {
    return Bookmark(
      courseId: doc['courseId'],
      userId: doc['userId'],
    );
  }

  // Create a Bookmark instance from JSON (optional, for API use)
  factory Bookmark.fromJson(Map<String, dynamic> data) {
    return Bookmark(
      courseId: data['courseId'],
      userId: data['userId'],
    );
  }
}
