import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/components/reviewdigest/review_card.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/service/instructor_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

/// Page to show Instructor details
class InstructorPage extends StatefulWidget {
  const InstructorPage(
      {super.key, required this.instructorId, required this.instructorService});
  final String instructorId;
  final InstructorService instructorService;

  @override
  State<InstructorPage> createState() => _InstructorPageState();
}

class _InstructorPageState extends State<InstructorPage> {
  late Future<Instructor?> futureInstructor;

  @override
  void initState() {
    super.initState();
    futureInstructor =
        widget.instructorService.getInstructorDetails(widget.instructorId);
  }

  /// Launches an external URL in the device's Browser
  Future<void> _launchUrl(String _url) async {
    Uri uri = Uri.parse(_url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Center(
        child: Column(
      children: [
        DiscourseAppBar(
            parentContext: context,
            pageName: 'Instructor Details',
            isForm: false),
        Container(
          constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.9,
              maxHeight: screenSize.height * 0.7),
          child: FutureBuilder(
              future: futureInstructor,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Instructor instructor = snapshot.data!;
                  return Semantics(
                    label:
                        'This is the instructor detail page for ${instructor.firstName} ${instructor.lastName}',
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: ExcludeSemantics(
                              child: Text(
                                '${instructor.firstName} ${instructor.lastName}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'RegularText',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: ExcludeSemantics(
                              child: Text(
                                'Instructor',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'RegularText',
                                    fontWeight: FontWeight.bold,
                                    color: AppColor().textActiveTertiary),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColor().separator))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MergeSemantics(
                                  child: Row(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: ExcludeSemantics(
                                              child: Icon(Icons.grade))),
                                      Semantics(
                                        label:
                                            'Rated ${instructor.averageCourseRating} stars',
                                        child: Text(
                                            '${instructor.averageCourseRating} Stars'),
                                      ),
                                    ],
                                  ),
                                ),
                                MergeSemantics(
                                  child: Row(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: ExcludeSemantics(
                                              child: Icon(Icons.school))),
                                      Semantics(
                                        label:
                                            'Difficulty rating is ${instructor.averageDifficultyRating}',
                                        child: Text(
                                            '${instructor.averageDifficultyRating} Difficulty Rating'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ExpansionTile(
                            initiallyExpanded: true,
                            tilePadding: const EdgeInsets.only(left: 0),
                            expandedAlignment: Alignment.centerLeft,
                            dense: true,
                            shape: Border(
                                bottom:
                                    BorderSide(color: AppColor().separator)),
                            title: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text('Rating Detail',
                                  style: TextStyle(
                                      fontFamily: 'RegularText', fontSize: 22)),
                            ),
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: const Text('Discourse Rating',
                                          style: TextStyle(
                                              fontFamily: 'RegularText',
                                              fontSize: 16)),
                                    ),
                                    Container(
                                      child: Semantics(
                                        label:
                                            'Discourse Rating is ${instructor.averageCourseRating} stars',
                                        child: RatingBarIndicator(
                                          itemBuilder: (context, idx) {
                                            return Icon(Icons.star,
                                                color: AppColor()
                                                    .starColorPrimary);
                                          },
                                          itemCount: 5,
                                          itemSize: 22,
                                          rating:
                                              instructor.averageCourseRating!,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: const Text('Difficulty Rating',
                                          style: TextStyle(
                                              fontFamily: 'RegularText',
                                              fontSize: 16)),
                                    ),
                                    Semantics(
                                      label:
                                          '${instructor.averageDifficultyRating} out of 5',
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text('Easy',
                                              style: TextStyle(
                                                  fontFamily: 'RegularText')),
                                          Slider(
                                            divisions: 8,
                                            label: instructor
                                                .averageDifficultyRating!
                                                .toString(),
                                            value: instructor
                                                .averageDifficultyRating!,
                                            min: 0.0,
                                            max: 5.0,
                                            onChanged: null,
                                          ),
                                          const Text('Hard',
                                              style: TextStyle(
                                                  fontFamily: 'RegularText'))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: const Text(
                                          'Rate My Professor Rating',
                                          style: TextStyle(
                                              fontFamily: 'RegularText',
                                              fontSize: 16)),
                                    ),
                                    Container(
                                      child: Semantics(
                                        label: instructor.externalRating != 0
                                            ? 'Rate My Professor Rating is ${instructor.externalRating} stars'
                                            : 'No rating',
                                        child: instructor.externalRating != 0
                                            ? RatingBarIndicator(
                                                itemBuilder: (context, idx) {
                                                  return Icon(Icons.star,
                                                      color: AppColor()
                                                          .starColorPrimary);
                                                },
                                                itemCount: 5,
                                                itemSize: 22,
                                                rating:
                                                    instructor.externalRating!,
                                              )
                                            : const Text('N/A'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: instructor.externalUrl!.isEmpty
                                    ? const SizedBox.shrink()
                                    : TextButton(
                                        onPressed: () =>
                                            _launchUrl(instructor.externalUrl!),
                                        child:
                                            const Text('View external website'),
                                      ),
                              ),
                            ],
                          ),
                          ExpansionTile(
                              initiallyExpanded: true,
                              tilePadding: const EdgeInsets.only(left: 0),
                              expandedAlignment: Alignment.centerLeft,
                              dense: true,
                              shape: Border(
                                  bottom:
                                      BorderSide(color: AppColor().separator)),
                              title: Container(
                                alignment: Alignment.centerLeft,
                                child: const Text('All Course Reviews',
                                    style: TextStyle(
                                        fontFamily: 'RegularText',
                                        fontSize: 22)),
                              ),
                              children: List.generate(
                                  instructor.courseReviewsForInstructor!.length,
                                  (idx) {
                                return IndexedSemantics(
                                    index: idx,
                                    child: ReviewCard(
                                      individualReview: instructor
                                          .courseReviewsForInstructor![idx],
                                      fromInstructorPage: true,
                                    ));
                              }))
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
              }),
        )
      ],
    ));
  }
}
