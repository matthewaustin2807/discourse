import 'package:discourse/service/discussion_service.dart';
import 'package:flutter/material.dart';

/// Like, Dislike, and Comment bar that is shown for Discussion Forum entries to allow liking and disliking posts.
class LikeDislikeCommentBar extends StatefulWidget {
  LikeDislikeCommentBar(
      {super.key,
      required this.id,
      required this.isReply,
      required this.likes,
      required this.dislikes,
      required this.replyLength,
      required this.discussionService});
  final bool isReply;
  final String id;
  int likes;
  int dislikes;
  final int replyLength;
  final DiscussionService discussionService;

  @override
  State<LikeDislikeCommentBar> createState() => _LikeDislikeCommentBarState();
}

class _LikeDislikeCommentBarState extends State<LikeDislikeCommentBar> {
   @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.only(left: 8),
          height: 48,
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Semantics(
                      label: '${widget.likes.toString()} likes',
                      child: Text(widget.likes.toString()),
                    ),
                    Semantics(
                      label: 'Like this post',
                      button: true,
                      child: IconButton(
                          padding: const EdgeInsets.only(top: 0),
                          iconSize: 24,
                          onPressed: () async {
                            await widget.discussionService.addLikeOrDislike(
                                widget.id, widget.isReply, true);
                            setState(() => widget.likes += 1);
                          },
                          icon: const Icon(Icons.arrow_circle_up_rounded,
                              color: Colors.black)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Semantics(
                      label: '${widget.dislikes.toString()} dislikes',
                      child: Text(widget.dislikes.toString()),
                    ),
                    Semantics(
                      label: 'Dislike this post',
                      button: true,
                      child: IconButton(
                          padding: const EdgeInsets.only(top: 0),
                          iconSize: 24,
                          onPressed: () async {
                            await widget.discussionService.addLikeOrDislike(
                                widget.id, widget.isReply, false);
                            setState(() => widget.dislikes += 1);
                          },
                          icon: const Icon(
                            Icons.arrow_circle_down_rounded,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          alignment: Alignment.center,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8, right: 3),
                child: ExcludeSemantics(
                    child: Icon(Icons.mode_comment_outlined,
                        size: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3, right: 8),
                child: Semantics(
                    label: '${widget.replyLength} comments',
                    child: Text(widget.replyLength.toString())),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
