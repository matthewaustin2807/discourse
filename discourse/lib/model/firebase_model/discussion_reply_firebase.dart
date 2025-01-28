import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class to represent a Discussion Reply in Firestore
class DiscussionReplyFirebase {
  DiscussionReplyFirebase({
    this.replyId,
    required this.replierId,
    required this.replierName,
    required this.replyBody,
    this.replies = const [],
    this.replyIds = const [],
    this.likes = 0,
    this.dislikes = 0,
    required this.datePosted,
  });

  String? replyId;
  final String? replierId;
  final String? replierName;
  final String replyBody;
  final List<String> replyIds;
  List<DiscussionReplyFirebase> replies;
  final int likes;
  final int dislikes;
  final String datePosted;

  Map<String, dynamic> toFirestore() {
    return {
      'replier_id': replierId,
      'replier_name': replierName,
      'likes': likes,
      'dislikes': dislikes,
      'reply_body': replyBody,
      'date_posted': datePosted,
      'reply_ids': replyIds,
    };
  }

  factory DiscussionReplyFirebase.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return DiscussionReplyFirebase(
        replyId: snapshot.reference.id,
        replierId: data!['replier_id'],
        replierName: data['replier_name'],
        replyBody: data['reply_body'],
        datePosted: data['date_posted'],
        replyIds: List<String>.from(data['reply_ids']),
        likes: data['likes'],
        dislikes: data['dislikes']);
  }

  Map<String, dynamic> toMap() {
    return {
      'replier_id': replierId,
      'replier_name': replierName,
      'likes': likes,
      'dislikes': dislikes,
      'reply_body': replyBody,
      'date_posted': datePosted,
      'reply_ids': replyIds,
    };
  }

  factory DiscussionReplyFirebase.fromDocument(Map<String, dynamic> data) {
    return DiscussionReplyFirebase(
        replyId: data['id'],
        replierId: data['replier_id'],
        replierName: data['replier_name'],
        replyBody: data['reply_body'],
        datePosted: data['date_posted'],
        replyIds: List<String>.from(data['reply_ids']),
        likes: data['likes'],
        dislikes: data['dislikes']);
  }
}
