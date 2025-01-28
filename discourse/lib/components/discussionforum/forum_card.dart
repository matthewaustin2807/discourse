import 'package:discourse/components/discussionforum/like_dislike_comment_bar.dart';
import 'package:discourse/components/tag_widget.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/discussion_entry_firebase.dart';
import 'package:discourse/model/firebase_model/discussion_reply_firebase.dart';
import 'package:discourse/service/discussion_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Discussion Forum card to be showin in the Discussion Forum page
class ForumCard extends StatefulWidget {
  const ForumCard(
      {super.key, required this.entry, required this.discussionService});
  final DiscussionEntryFirebase entry;
  final DiscussionService discussionService;

  @override
  State<ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  late int likes;
  late int dislikes;

  @override
  void initState() {
    super.initState();
    likes = widget.entry.likes;
    dislikes = widget.entry.dislikes;
  }

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
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return Semantics(
        label: 'Go to this discussion',
        button: true,
        child: GestureDetector(
          onTap: () {
            appState.changePages('/discussionentry',
                param1: widget.entry.entryId);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: AppColor().separator, width: 1.5))),
            constraints: BoxConstraints(
              maxWidth: screenSize.width,
            ),
            child: LayoutBuilder(builder: (context, topLevelConstraints) {
              return Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(right: 8),
                          child: Semantics(
                            label: 'Posted by ${widget.entry.username}',
                            child: Text(widget.entry.username!),
                          ),
                        ),
                        const ExcludeSemantics(
                            child: Icon(Icons.circle, size: 6)),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: Semantics(
                              label: 'Posted on ${widget.entry.datePosted}',
                              child: Text(widget.entry.datePosted)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      children: [
                        Text(widget.entry.discussionTitle,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RegularText',
                                fontSize: 16))
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Semantics(
                      label:
                          'List of tags associated with this discussion entry',
                      child: Wrap(
                          children:
                              List.generate(widget.entry.tags.length, (idx) {
                        return IndexedSemantics(
                            index: idx,
                            child: TagWidget(tagName: widget.entry.tags[idx]));
                      })),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 12),
                      child: LikeDislikeCommentBar(
                        id: widget.entry.entryId!,
                        isReply: false,
                        likes: widget.entry.likes,
                        dislikes: widget.entry.dislikes,
                        replyLength: getTotalReplies(widget.entry.replies),
                        discussionService: widget.discussionService,
                      )),
                ],
              );
            }),
          ),
        ));
  }
}
