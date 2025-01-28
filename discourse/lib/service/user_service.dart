import 'package:firebase_auth/firebase_auth.dart';

/// Service class to handle User API calls
class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the current user's UID
  Future<String> getCurrentUserUid() async {
    User? user = _auth.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      throw Exception("User not logged in");
    }
  }

  /// Get the current user's display name
  Future<String> getUserDisplayName() async {
    User? user = _auth.currentUser;

    if (user != null) {
      if (user.displayName != null) {
        return user.displayName!;
      }
      return user.uid;
    } else {
      throw Exception("Display name is not set or user is not logged in");
    }
  }
}


