import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/discussionforum/entry_reply.dart';
import 'package:discourse/components/discussionforum/like_dislike_comment_bar.dart';
import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/discussion_entry_firebase.dart';
import 'package:discourse/model/firebase_model/discussion_reply_firebase.dart';
import 'package:discourse/service/discussion_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Page that will show a particular Discussion Entry
class DiscussionEntryPage extends StatefulWidget {
  const DiscussionEntryPage(
      {super.key, required this.entryId, required this.discussionService});
  final String entryId;
  final DiscussionService discussionService;

  @override
  State<DiscussionEntryPage> createState() => _DiscussionEntryPageState();
}

class _DiscussionEntryPageState extends State<DiscussionEntryPage> {
  late Future<DiscussionEntryFirebase?> futureEntry;

  @override
  void initState() {
    super.initState();
    futureEntry = widget.discussionService.getDiscussionEntry(widget.entryId);
  }

  /// Refreshed the page everytime a new comment is added by the user
  void refreshPage() {
    setState(() {
      futureEntry = widget.discussionService.getDiscussionEntry(widget.entryId);
    });
  }

  /// Recursively gets all total replies for that entry
  int getTotalReplies(List<DiscussionReplyFirebase> replies) {
    if (replies.isEmpty) {
      return 0;
    }
    int total = 0;
    for (DiscussionReplyFirebase reply in replies) {
      total += getTotalReplies(reply.replies);
    }
    return total + replies.length;
  }

  Future openReplyDialog(
      DiscussionEntryFirebase entry, BuildContext context) async {
    String? reply = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          String reply = "";
          Size screenSize = MediaQuery.of(context).size;

          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: screenSize.height * 0.3,
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Semantics(
                        label: 'Join the conversation',
                        textField: true,
                        child: TextFormField(
                          onChanged: (value) {
                            reply = value;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColor().textError)),
                            errorStyle: TextStyle(color: AppColor().textError),
                            hintText: 'Join the conversation...',
                            hintStyle: TextStyle(
                                fontFamily: 'RegularText',
                                color: AppColor().textInactive,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    alignment: Alignment.bottomRight,
                    child: Semantics(
                      label: 'Post',
                      button: true,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop(reply);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              AppColor().buttonActive),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                        ),
                        child: const Text(
                          'Post!',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'RegularText'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    return reply;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Column(children: [
          DiscourseAppBar(parentContext: context, pageName: '', isForm: false),
          Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.9,
                maxHeight: screenSize.height * 0.73,
              ),
              child: FutureBuilder(
                  future: futureEntry,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      DiscussionEntryFirebase entry = snapshot.data!;
                      return ListView(
                        padding: const EdgeInsets.only(top: 0),
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColor().separator,
                                        width: 1.5))),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Semantics(
                                        label: 'Posted by ${entry.userId}',
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 8),
                                          child: Text(entry.username!),
                                        ),
                                      ),
                                      const ExcludeSemantics(
                                          child: Icon(Icons.circle, size: 6)),
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: Semantics(
                                            label: entry.datePosted,
                                            child: Text(
                                              entry.datePosted,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      entry.discussionTitle,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'RegularText',
                                      ),
                                    )),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    entry.discussionBody,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'RegularText',
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(top: 8),
                                  child: Semantics(
                                    label:
                                        'List of tags associated with this discussion entry',
                                    child: Wrap(
                                        children: List.generate(entry.tags.length,
                                            (idx) {
                                      return IndexedSemantics(
                                          index: idx,
                                          child: TagWidget(
                                              tagName: entry.tags[idx]));
                                    })),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      LikeDislikeCommentBar(
                                        id: entry.entryId!,
                                        isReply: false,
                                        likes: entry.likes,
                                        dislikes: entry.dislikes,
                                        replyLength:
                                            getTotalReplies(entry.replies),
                                        discussionService:
                                            widget.discussionService,
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Semantics(
                                          excludeSemantics: true,
                                          label: 'Reply to this entry',
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                                iconColor: Colors.black,
                                                foregroundColor: Colors.black),
                                            onPressed: () async {
                                              String? reply =
                                                  await openReplyDialog(
                                                      entry, context);
                                              if (reply != null &&
                                                  reply.isNotEmpty) {
                                                DiscussionReplyFirebase disReply =
                                                    DiscussionReplyFirebase(
                                                        replierId: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                        replierName: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .displayName,
                                                        replyBody: reply,
                                                        replyIds: [],
                                                        likes: 0,
                                                        dislikes: 0,
                                                        datePosted: DateFormat(
                                                                'MM/dd/yyyy')
                                                            .format(
                                                                DateTime.now()));
                                                //uploading the reply to the firebase
                                                await widget.discussionService
                                                    .addReplyToEntry(
                                                        disReply, entry.entryId!);
                                                refreshPage();
                                              }
                                            },
                                            child: const Row(
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.only(right: 6),
                                                    child: Icon(
                                                        Icons.reply_rounded)),
                                                Text('Reply',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'RegularText'))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Semantics(
                              label: 'List of replies to this entry',
                              child: Column(
                                  children: entry.replyIds.isEmpty
                                      ? []
                                      : List.generate(entry.replyIds.length,
                                          (idx) {
                                          return IndexedSemantics(
                                              index: idx,
                                              child: EntryReply(
                                                level: 0,
                                                reply: entry.replies[idx],
                                                callback: refreshPage,
                                                discussionService:
                                                    widget.discussionService,
                                              ));
                                        })),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.stackTrace}');
                    } else {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                  }),
            ),
          ),
        ]),
      ),
    );
  }
}
