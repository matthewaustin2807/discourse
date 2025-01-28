import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/firebase_model/discussion_reply_firebase.dart';

/// Model class to represent a Discussion Entry in Firebase
class DiscussionEntryFirebase {
  DiscussionEntryFirebase({
    this.entryId,
    required this.userId,
    this.username,
    required this.discussionTitle,
    this.likes = 0,
    this.dislikes = 0,
    required this.tags,
    required this.discussionBody,
    required this.datePosted,
    this.replies = const [],
    this.replyIds = const [],
  });
  
  String? entryId;
  final String userId;
  String? username;
  final int likes;
  final int dislikes;
  String discussionTitle;
  List<String> tags;
  String discussionBody;
  String datePosted;
  List<String> replyIds;
  List<DiscussionReplyFirebase> replies;


  Map<String, dynamic> toFirestore() {
    return {
      'poster_id': userId,
      'poster_name': username,
      'likes': likes,
      'dislikes': dislikes,
      'discussion_title': discussionTitle,
      'tags': tags,
      'discussion_body': discussionBody,
      'date_posted': datePosted,
      'reply_ids': replyIds,
    };
  }

  factory DiscussionEntryFirebase.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data();

    return DiscussionEntryFirebase(
      entryId: snapshot.reference.id,
      userId: data!['poster_id'],
      likes: data['likes'],
      dislikes: data['dislikes'],
      username: data['poster_name'], 
      discussionTitle: data['discussion_title'], 
      tags: List<String>.from(data['tags']), 
      discussionBody: data['discussion_body'],
      datePosted: data['date_posted'],
      replyIds: List<String>.from(data['reply_ids'])
      );
  }

  // Create a DiscussionEntry instance from Firestore DocumentSnapshot
  factory DiscussionEntryFirebase.fromDocument(Map<String, dynamic> doc) {
    return DiscussionEntryFirebase(
      userId: doc['poster_id'],
      likes: doc['likes'],
      dislikes: doc['dislikes'],
      username: doc['poster_name'], 
      discussionTitle: doc['discussion_title'], 
      tags: List<String>.from(doc['tags']), 
      discussionBody: doc['discussion_body'],
      datePosted: doc['date_posted'],
      replyIds: List<String>.from(doc['reply_ids'])
      );
  }
}
