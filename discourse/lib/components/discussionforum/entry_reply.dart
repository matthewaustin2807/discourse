import 'package:discourse/components/discussionforum/like_dislike_comment_bar.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/discussion_reply_firebase.dart';
import 'package:discourse/service/discussion_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Reply widget that will hold a reply to a discussion forum entry
class EntryReply extends StatefulWidget {
  const EntryReply(
      {super.key,
      required this.level,
      required this.reply,
      required this.callback,
      required this.discussionService});
  final int level;
  final DiscussionReplyFirebase reply;
  final callback;
  final DiscussionService discussionService;

  @override
  State<EntryReply> createState() => _EntryReplyState();
}

class _EntryReplyState extends State<EntryReply> {
  final DiscussionService discussionService = DiscussionService();
  bool _expanded = true;

  /// Recursively gets all the replies for a particular entry
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

  @override
  Widget build(BuildContext context) {
    Future openReplyDialog() async {
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
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
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
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        key: const Key('postListing'),
                        onPressed: () async {
                          Navigator.of(context).pop(reply);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              AppColor().buttonActive),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
                  ],
                ),
              ),
            );
          });
      return reply;
    }

    return Semantics(
        expanded: _expanded,
        button: true,
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() => _expanded = value);
          },
          shape: Border(left: BorderSide(color: AppColor().separator)),
          showTrailingIcon: false,
          childrenPadding: EdgeInsets.only(left: (widget.level * 1) + 16),
          initiallyExpanded: true,
          dense: true,
          tilePadding: const EdgeInsets.only(left: 8),
          title: Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Semantics(
                          label: 'Posted by ${widget.reply.replierName}',
                          child: Text(widget.reply.replierName!,
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                      const ExcludeSemantics(
                          child: Icon(Icons.circle, size: 6)),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: Semantics(
                            label: 'Posted on ${widget.reply.datePosted}',
                            child: Text(widget.reply.datePosted,
                                style: const TextStyle(fontSize: 12))),
                      ),
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.reply.replyBody,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'RegularText',
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LikeDislikeCommentBar(
                          id: widget.reply.replyId!,
                          isReply: true,
                          likes: widget.reply.likes,
                          dislikes: widget.reply.dislikes,
                          replyLength: getTotalReplies(widget.reply.replies),
                          discussionService: widget.discussionService,),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Semantics(
                          button: true,
                          label: 'Reply to this entry',
                          child: TextButton(
                            style: TextButton.styleFrom(
                                iconColor: Colors.black,
                                foregroundColor: Colors.black),
                            onPressed: () async {
                              String? reply = await openReplyDialog();
                              if (reply != null && reply.isNotEmpty) {
                                DiscussionReplyFirebase disReply =
                                    DiscussionReplyFirebase(
                                        replierId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        replierName: FirebaseAuth
                                            .instance.currentUser!.displayName,
                                        replyBody: reply,
                                        replyIds: [],
                                        datePosted: DateFormat('MM/dd/yyyy')
                                            .format(DateTime.now()));
                                //uploading the reply to the firebase
                                await discussionService.addReplyToReply(
                                    disReply, widget.reply.replyId!);
                                widget.callback();
                              }
                            },
                            child: const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.reply_rounded,
                                    size: 16,
                                  ),
                                ),
                                Text('Reply',
                                    style: TextStyle(
                                        fontFamily: 'RegularText',
                                        fontSize: 13))
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
          children: widget.reply.replies.isEmpty
              ? []
              : List.generate(widget.reply.replies.length, (idx) {
                  return EntryReply(
                    level: widget.level + 1,
                    reply: widget.reply.replies[idx],
                    callback: widget.callback,
                    discussionService: widget.discussionService,
                  );
                }),
        ));
  }
}
