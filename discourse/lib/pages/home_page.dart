import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/home_page_card.dart';
import 'package:discourse/components/search_module.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/service/course_review_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// HomePage widget
class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.courseReviewService,
      required this.firebaseAuth});
  final FirebaseAuth firebaseAuth;
  final CourseReviewService courseReviewService;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Course>> futureCourses;
  Future editDisplayName() async {
    String? displayName = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          String? displayName;
          return AlertDialog(
            title: const ExcludeSemantics(
                child: Text('Before proceeding, please select a username!')),
            content: Semantics(
              textField: true,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter your new username',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  displayName = value;
                },
              ),
            ),
            actions: [
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

  @override
  void initState() {
    super.initState();
    futureCourses = widget.courseReviewService.getAllExistingReviews();
    if (widget.firebaseAuth.currentUser!.displayName == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        editDisplayName();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    void goToReviewDigest(String courseName) {
      appState.changePages('/reviewdigest', param1: courseName);
    }

    return Center(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          DiscourseAppBar(
            parentContext: context,
            pageName: 'Discourse',
            isForm: false,
          ),
          FutureBuilder(
              future: futureCourses,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              left: 14, bottom: 8),
                          child: const Text('Quick Search a Review:',
                              style: TextStyle(
                                  fontFamily: 'RegularText',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))),
                      SearchModule(
                          data: snapshot.data!,
                          callbackAction: goToReviewDigest),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: screenSize.height * 0.7,
                        ),
                        child: GridView.count(
                          padding: const EdgeInsets.only(top: 24),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: List.generate(4, (idx) {
                            return IndexedSemantics(
                                index: idx, child: HomePageCard(idx));
                          }),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator.adaptive(
                    semanticsLabel: 'Still waiting for data',
                  );
                }
              }),
        ],
      ),
    );
  }
}
