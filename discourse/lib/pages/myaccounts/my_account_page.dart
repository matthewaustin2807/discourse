import 'package:auto_size_text/auto_size_text.dart';
import 'package:discourse/components/myaccount/compact_bookmark_card.dart';
import 'package:discourse/components/myaccount/compact_review_card.dart';
import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/course_review.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/service/course_review_service.dart';
import 'package:discourse/service/upload_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// My Account Page
class MyAccount extends StatefulWidget {
  const MyAccount(
      {super.key,
      required this.firebaseAuth,
      required this.courseReviewService,
      required this.fileUploadService});
  final FileUploadService fileUploadService;
  final CourseReviewService courseReviewService;
  final FirebaseAuth firebaseAuth;

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String? _imageUrl;
  final picker = ImagePicker();

  /// Gets an image from the device gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String imageUrl =
          await widget.fileUploadService.uploadProfilePicture(pickedFile);
      await widget.firebaseAuth.currentUser!.updatePhotoURL(imageUrl);
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  /// Edits the current user's display name and push it to Firebase
  Future editDisplayName() async {
    String? displayName = await showDialog(
        context: context,
        builder: (context) {
          String? displayName;
          return AlertDialog(
            title:
                const ExcludeSemantics(child: Text('Edit your Display Name')),
            content: Semantics(
              textField: true,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter your new name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  displayName = value;
                },
              ),
            ),
            actions: [
              Semantics(
                label: 'Cancel',
                button: true,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel',
                      style: TextStyle(
                          fontFamily: 'RegularText',
                          color: AppColor().textError)),
                ),
              ),
              Semantics(
                  label: 'Save',
                  button: true,
                  child: TextButton(
                      onPressed: () => Navigator.pop(context, displayName),
                      child: Text('Save',
                          style: TextStyle(
                              fontFamily: 'RegularText',
                              color: AppColor().darkPurple)))),
            ],
          );
        });
    await widget.firebaseAuth.currentUser!.updateDisplayName(displayName);
    return displayName;
  }

  late Future<List<IndividualCourseReview>> futureMyReviews;
  late Future<List<CourseReview>> futureMyBookmarks;
  late String currentEmail;
  String? _displayName;

  @override
  void initState() {
    super.initState();
    futureMyReviews = widget.courseReviewService
        .getMyReviews(widget.firebaseAuth.currentUser!.uid);
    futureMyBookmarks = widget.courseReviewService
        .getMyBookmarks(widget.firebaseAuth.currentUser!.uid);

    if (widget.firebaseAuth.currentUser!.photoURL != null) {
      _imageUrl = widget.firebaseAuth.currentUser!.photoURL!;
    }
    currentEmail = widget.firebaseAuth.currentUser!.email!;
    if (widget.firebaseAuth.currentUser!.displayName != null) {
      _displayName = widget.firebaseAuth.currentUser!.displayName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return Center(
      child: Column(
        children: [
          DiscourseAppBar(
              parentContext: context, pageName: 'My Account', isForm: false),
          Container(
              constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.95,
                maxHeight: screenSize.height * 0.7,
              ),
              child: LayoutBuilder(builder: (context, boxConstraints) {
                return FutureBuilder(
                    future: Future.wait([futureMyReviews, futureMyBookmarks]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Semantics(
                                      label: 'Change Avatar Picture',
                                      button: true,
                                      child: GestureDetector(
                                        onTap: getImageFromGallery,
                                        child: CircleAvatar(
                                          backgroundImage: _imageUrl == null
                                              ? null
                                              : NetworkImage(_imageUrl!),
                                          backgroundColor: AppColor().separator,
                                          radius: 64,
                                          child: _imageUrl == null
                                              ? const Icon(Icons.photo_camera)
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: screenSize.width * 0.6
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 14),
                                            child: AutoSizeText(
                                                _displayName == null
                                                    ? currentEmail
                                                    : _displayName!,
                                                style: const TextStyle(
                                                    fontFamily: 'RegularText',
                                                    fontSize: 24), maxLines: 1,),
                                          ),
                                          Semantics(
                                              label: 'Edit Display Name',
                                              button: true,
                                              child: TextButton(
                                                onPressed: () async {
                                                  String? displayName =
                                                      await editDisplayName();
                                                  if (displayName != null) {
                                                    setState(() =>
                                                        _displayName =
                                                            displayName);
                                                  }
                                                },
                                                child: const Text(
                                                    'Edit Display Name'),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 8),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Semantics(
                                      label: 'Go to my reviews',
                                      button: true,
                                      child: TextButton(
                                        onPressed: () {
                                          appState.changePages('/myreviews',
                                              param1: snapshot.data![0]);
                                        },
                                        child: const Text('My Reviews',
                                            style: TextStyle(
                                                fontFamily: 'RegularText',
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: boxConstraints.maxWidth,
                                          maxHeight:
                                              boxConstraints.maxHeight * 0.3),
                                      child: Semantics(
                                          label:
                                              'Browse your recent reviews through this horizontal list',
                                          child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: snapshot
                                                          .data![0].length <
                                                      4
                                                  ? snapshot.data![0].isNotEmpty
                                                      ? List.generate(
                                                          snapshot.data![0]
                                                              .length, (idx) {
                                                          return CompactReviewCard(
                                                            review: snapshot
                                                                        .data![
                                                                    0][idx]
                                                                as IndividualCourseReview,
                                                          );
                                                        })
                                                      : [
                                                          Container(
                                                              width:
                                                                  screenSize
                                                                          .width *
                                                                      0.95,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Text(
                                                                  'Your reviewed courses will appear here',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'RegularText',
                                                                      fontSize:
                                                                          18)))
                                                        ]
                                                  : List.generate(4, (idx) {
                                                      return IndexedSemantics(
                                                          index: idx,
                                                          child: CompactReviewCard(
                                                              review: snapshot
                                                                          .data![
                                                                      0][idx]
                                                                  as IndividualCourseReview));
                                                    }))),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Semantics(
                                      label: 'Go to your bookmarks',
                                      button: true,
                                      child: TextButton(
                                        onPressed: () {
                                          appState.changePages('/mybookmarks');
                                        },
                                        child: const Text('My Bookmarks',
                                            style: TextStyle(
                                                fontFamily: 'RegularText',
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: boxConstraints.maxWidth,
                                          maxHeight:
                                              boxConstraints.maxHeight * 0.3),
                                      child: Semantics(
                                        label:
                                            'Browse through your recent bookmarked course through this horizontal list',
                                        child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: snapshot.data![1].length <
                                                    4
                                                ? snapshot.data![1].isNotEmpty
                                                    ? List.generate(
                                                        snapshot.data![1]
                                                            .length, (idx) {
                                                        return CompactBookmarkCard(
                                                          review: snapshot
                                                                  .data![1][idx]
                                                              as CourseReview,
                                                        );
                                                      })
                                                    : [
                                                        Container(
                                                            width: screenSize
                                                                    .width *
                                                                0.95,
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                                'Bookmarked courses will appear here',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'RegularText',
                                                                    fontSize:
                                                                        18)))
                                                      ]
                                                : List.generate(4, (idx) {
                                                    return CompactBookmarkCard(
                                                        review: snapshot
                                                                .data![1][idx]
                                                            as CourseReview);
                                                  })),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator.adaptive(
                          semanticsLabel: 'Still waiting for data',
                        ));
                      }
                    });
              })),
        ],
      ),
    );
  }
}
