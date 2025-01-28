import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/model/firebase_model/discussion_entry_firebase.dart';
import 'package:discourse/model/firebase_model/discussion_reply_firebase.dart';
import 'package:discourse/service/service.dart';

/// Discussion service class to handle grabbing Discussion data from Firestore
class DiscussionService extends Service {
  final CollectionReference _discussionEntryCollection =
      FirebaseFirestore.instance.collection('discussion_entry');

  final CollectionReference _discussionReplyCollection =
      FirebaseFirestore.instance.collection('discussion_reply');

  /// Add a new discussion entry to Firestore
  Future<void> addDiscussionEntry(DiscussionEntryFirebase entry) async {
    final _discussionRef = _discussionEntryCollection.withConverter(
        fromFirestore: DiscussionEntryFirebase.fromFirestore,
        toFirestore: (DiscussionEntryFirebase entry, _) => entry.toFirestore());

    _discussionRef.add(entry);
  }

  /// Add a reply to an entry in Firestore
  Future<void> addReplyToEntry(
      DiscussionReplyFirebase reply, String parentId) async {
    final _discussionReplyRef = _discussionReplyCollection.withConverter(
        fromFirestore: DiscussionReplyFirebase.fromFirestore,
        toFirestore: (DiscussionReplyFirebase reply, _) => reply.toFirestore());
    // Add reply to the discussion_reply collection
    final docRef = await _discussionReplyRef.add(reply);

    // Add the reply ID to the replyId list in the parent discussion entry
    await _discussionEntryCollection.doc(parentId).update({
      'reply_ids': FieldValue.arrayUnion([docRef.id]),
    });
  }

  /// Add a new reply to reply to Firestore
  Future<void> addReplyToReply(
      DiscussionReplyFirebase reply, String parentId) async {
    final _discussionReplyRef = _discussionReplyCollection.withConverter(
        fromFirestore: DiscussionReplyFirebase.fromFirestore,
        toFirestore: (DiscussionReplyFirebase reply, _) => reply.toFirestore());

    // Add reply to the discussion_reply collection
    final docRef = await _discussionReplyRef.add(reply);
    await _discussionReplyCollection.doc(parentId).update({
      'reply_ids': FieldValue.arrayUnion([docRef.id]),
    });
  }

  /// Gets all Discussion Entries from Firestore
  Future<List<DiscussionEntryFirebase>> getAllDiscussionEntries() async {
    final _discussionRef = _discussionEntryCollection.withConverter(
        fromFirestore: DiscussionEntryFirebase.fromFirestore,
        toFirestore: (DiscussionEntryFirebase entry, _) => entry.toFirestore());

    List<DiscussionEntryFirebase> entries = [];

    await _discussionRef.get().then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        DiscussionEntryFirebase entry = doc.data();
        entry.entryId = doc.reference.id;
        List<DiscussionReplyFirebase> replies =
            await Future.wait(entry.replyIds.map((replyId) async {
          return await getReplyWithNestedReplies(replyId);
        }).toList());
        entry.replies = replies;
        entries.add(entry);
      }
    });

    return entries;
  }

  /// Gets a Discussion Entry given its id
  Future<DiscussionEntryFirebase?> getDiscussionEntry(String entryId) async {
    DocumentSnapshot doc = await _discussionEntryCollection.doc(entryId).get();
    if (doc.exists) {
      DiscussionEntryFirebase result = DiscussionEntryFirebase.fromDocument(
          doc.data() as Map<String, dynamic>);
      result.entryId = entryId;

      List<DiscussionReplyFirebase> replies =
          await Future.wait(result.replyIds.map((replyId) async {
        return await getReplyWithNestedReplies(replyId);
      }).toList());
      result.replies = replies;
      return result;
    }
    return null;
  }

  /// Adds Like or Dislike to an Entry in Firestore
  Future<void> addLikeOrDislike(String id, bool isReply, bool isLike) async {
    final collection =
        isReply ? _discussionReplyCollection : _discussionEntryCollection;
    final field = isLike ? 'likes' : 'dislikes';

    await collection.doc(id).update({
      field: FieldValue.increment(1),
    });
  }

  /// Removes Like or Dislike to an Entry in Firestore
  Future<void> removeLikeOrDislike(String id, bool isReply, bool isLike) async {
    final collection =
        isReply ? _discussionReplyCollection : _discussionEntryCollection;
    final field = isLike ? 'likes' : 'dislikes';

    await collection.doc(id).update({
      field: FieldValue.increment(-1),
    });
  }

  /// Delete a discussion entry by its document ID
  Future<void> deleteDiscussionEntry(String id) async {
    await _discussionEntryCollection.doc(id).delete();
  }

  /// Update a reply
  Future<void> updateReply(
      String replyId, Map<String, dynamic> updatedData) async {
    await _discussionReplyCollection.doc(replyId).update(updatedData);
  }

  // Delete a reply by its document ID
  Future<void> deleteReply(String replyId) async {
    await _discussionReplyCollection.doc(replyId).delete();
  }

  /// Recursively gets all replies and all of its replies from Firestore
  Future<DiscussionReplyFirebase> getReplyWithNestedReplies(String id) async {
    final _discussionReplyRef = _discussionReplyCollection.withConverter(
        fromFirestore: DiscussionReplyFirebase.fromFirestore,
        toFirestore: (DiscussionReplyFirebase reply, _) => reply.toFirestore());

    DiscussionReplyFirebase? reply;
    await _discussionReplyRef.doc(id).get().then((querySnapshot) async {
      reply = querySnapshot.data();
      List<DiscussionReplyFirebase> nestedReplies = await Future.wait(reply!
          .replyIds
          .map((replyId) async => await getReplyWithNestedReplies(replyId))
          .toList());
      reply!.replies = nestedReplies;
    });
    return reply!;
  }
}
