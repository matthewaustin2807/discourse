import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/course.dart';
import 'package:discourse/model/firebase_model/individual_course_review.dart';
import 'package:discourse/model/instructor.dart';
import 'package:discourse/service/course_review_service.dart';
import 'package:discourse/service/course_service.dart';
import 'package:discourse/service/instructor_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

/// Page for Writing New Reviews.
class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage(
      {super.key,
      required this.courseService,
      required this.instructorService});
  final CourseService courseService;
  final InstructorService instructorService;

  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  final _formKey = GlobalKey<FormState>();

  bool _showEmptyTags = false;

  Course? selectedCourse;
  Instructor? selectedInstructor;
  double difficultyRating = 3.0;
  double overallRating = 2.5;
  String? selectedGrade;
  String? selectedWorkload;
  String? selectedSemester;
  String? selectedYear;
  String? reviewDetail;
  final List<String> _tags = [];

  /// Validates the inputs entered by the user.
  bool _validateInputs() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (_tags.isNotEmpty) {
        setState(() => _showEmptyTags = false);
        return true;
      }
      setState(() => _showEmptyTags = true);
      return false;
    }
    if (_tags.isEmpty) {
      setState(() => _showEmptyTags = true);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return Center(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          DiscourseAppBar(
              parentContext: context, pageName: 'Write a Review', isForm: true),
          Container(
            padding: const EdgeInsets.all(8),
            constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.95,
                maxHeight: screenSize.height * 0.75),
            child: LayoutBuilder(
              builder: (context, topLevelConstraints) {
                return SingleChildScrollView(
                  key: const Key('singleChildScrollView'),
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              ExcludeSemantics(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: const Text(
                                      'Search for a course to review',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'RegularText')),
                                ),
                              ),
                              Semantics(
                                  label: 'Search for a course to review',
                                  textField: true,
                                  child: SearchableDropdownFormField<
                                      Course>.future(
                                    hintText: const Text('Search for a course'),
                                    margin: const EdgeInsets.all(15),
                                    futureRequest: () async {
                                      final availableCourses = await widget
                                          .courseService
                                          .getAllCourse();
                                      return availableCourses
                                          .map((e) => SearchableDropdownMenuItem<
                                                  Course>(
                                              label:
                                                  '${e.courseNumber} ${e.courseName}',
                                              child: Semantics(
                                                label:
                                                    '${e.courseNumber} ${e.courseName}',
                                                child: Text(
                                                  '${e.courseNumber}: ${e.courseName}',
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          'RegularText'),
                                                ),
                                              ),
                                              value: e))
                                          .toList();
                                    },
                                    onChanged: (Course? course) {
                                      _validateInputs();
                                      setState(() => selectedCourse = course);
                                    },
                                    validator: (val) {
                                      if (val == null) {
                                        return "Please select a course";
                                      }
                                      return null;
                                    },
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: const Text(
                                  'When did you take this course?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'RegularText')),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 64,
                                    child: Semantics(
                                      label:
                                          'Select semester from the dropdown menu',
                                      button: true,
                                      child:
                                          SearchableDropdownFormField<String>(
                                        hintText:
                                            const Text('Search a semester'),
                                        items: ['Fall', 'Spring', 'Summer']
                                            .map((e) =>
                                                SearchableDropdownMenuItem(
                                                    label: e,
                                                    child: Text(e,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'RegularText')),
                                                    value: e))
                                            .toList(),
                                        onChanged: (String? semester) {
                                          _validateInputs();
                                          setState(() =>
                                              selectedSemester = semester);
                                        },
                                        validator: (semester) {
                                          if (semester == null) {
                                            return "Please enter semester";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: SizedBox(
                                    height: 64,
                                    child: Semantics(
                                      label:
                                          'Select a year from the dropdown menu',
                                      child:
                                          SearchableDropdownFormField<String>(
                                        hintText: const Text('Select a year'),
                                        items: List.generate(
                                                10,
                                                (index) =>
                                                    (DateTime.now().year -
                                                            index)
                                                        .toString())
                                            .map((year) =>
                                                SearchableDropdownMenuItem(
                                                  label: year,
                                                  value: year,
                                                  child: Semantics(
                                                      button: true,
                                                      child: Text(year)),
                                                ))
                                            .toList(),
                                        onChanged: (String? year) {
                                          _validateInputs();
                                          setState(() => selectedYear = year);
                                        },
                                        validator: (year) {
                                          if (year == null) {
                                            return "Please select a year";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          child: Column(
                            children: [
                              ExcludeSemantics(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: const Text(
                                      'Who did you take this course with?',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'RegularText')),
                                ),
                              ),
                              Semantics(
                                label: 'Who did you take this course with?',
                                textField: true,
                                child: SearchableDropdownFormField<
                                    Instructor>.future(
                                  hintText: const Text('Select an instructor'),
                                  margin: const EdgeInsets.all(15),
                                  futureRequest: () async {
                                    final availableInstructors = await widget
                                        .instructorService
                                        .getAllInstructors();
                                    return availableInstructors
                                        .map((e) => SearchableDropdownMenuItem<
                                                Instructor>(
                                            label:
                                                '${e.firstName} ${e.lastName}',
                                            child: Semantics(
                                              label:
                                                  '${e.firstName} ${e.lastName}',
                                              child: Text(
                                                '${e.firstName} ${e.lastName}',
                                                style: const TextStyle(
                                                    fontFamily: 'RegularText'),
                                              ),
                                            ),
                                            value: e))
                                        .toList();
                                  },
                                  onChanged: (Instructor? instructor) {
                                    _validateInputs();
                                    setState(
                                        () => selectedInstructor = instructor);
                                  },
                                  validator: (instructor) {
                                    if (instructor == null) {
                                      return "Please select an instructor";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ExcludeSemantics(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: const Text('Estimated Workload/Week',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'RegularText')),
                          ),
                        ),
                        Semantics(
                          label:
                              'Select the estimated workload/week using the dropdown menu',
                          button: true,
                          child: SearchableDropdownFormField<String>(
                            margin: const EdgeInsets.all(15),
                            hintText: const Text(
                                'Choose the estimated workload in hours/week'),
                            items: [
                              '1-3',
                              '4-6',
                              '7-9',
                              '10-12',
                              '13-15',
                              '16-18',
                              '19-20',
                              '21 or more'
                            ]
                                .map((e) => SearchableDropdownMenuItem<String>(
                                      value: e,
                                      label: e,
                                      child: Semantics(
                                        button: true,
                                        child: Text('$e Hours'),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (String? workload) {
                              _validateInputs();
                              setState(
                                  () => selectedWorkload = '$workload hrs');
                            },
                            validator: (workload) {
                              if (workload == null) {
                                return "Please enter the estimated workload/week";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ExcludeSemantics(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: const Text('Grade Received',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'RegularText')),
                          ),
                        ),
                        Semantics(
                          label:
                              'Select your grade received in this course using the dropdown menu',
                          button: true,
                          child: SearchableDropdownFormField<String>(
                            margin: const EdgeInsets.all(15),
                            hintText: const Text(
                                'Choose the grade you received for this course'),
                            items: ['A', 'A-', 'B+', 'B', 'B-', 'C or below']
                                .map((grade) => SearchableDropdownMenuItem(
                                      label: grade,
                                      value: grade,
                                      child: Semantics(
                                        button: true,
                                        child: Text(grade),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (String? grade) {
                              _validateInputs();
                              setState(() => selectedGrade = grade);
                            },
                            validator: (grade) {
                              if (grade == null) {
                                return "Please select the grade you've received";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _tags.map((tag) {
                            return Semantics(
                                label: '$tag. Tap to remove this tag',
                                liveRegion: true,
                                button: true,
                                child: Chip(
                                  label: Text(tag),
                                  onDeleted: () {
                                    _validateInputs();
                                    setState(() => _tags.remove(tag));
                                  },
                                ));
                          }).toList(),
                        ),
                        Row(
                          children: [
                            Semantics(
                              label: 'Add tags for this course',
                              button: true,
                              child: ActionChip(
                                label: const Text('+ Add tags for this course'),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String newTag = '';
                                      return AlertDialog(
                                        title: const Text('Add a Tag'),
                                        content: Semantics(
                                          label: 'Enter a tag name',
                                          textField: true,
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              labelText: 'Enter tag name',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              newTag = value;
                                            },
                                          ),
                                        ),
                                        actions: [
                                          Semantics(
                                            button: true,
                                            label: 'Cancel',
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel',
                                                  style: TextStyle(
                                                      color: AppColor()
                                                          .textError)),
                                            ),
                                          ),
                                          Semantics(
                                            button: true,
                                            label: 'Add',
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (newTag.isNotEmpty) {
                                                  _validateInputs();
                                                  setState(
                                                      () => _tags.add(newTag));
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Add'),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Semantics(
                                label: 'Learn more about tags',
                                button: true,
                                child: IconButton(
                                  icon: const Icon(Icons.info_outline_rounded),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const AlertDialog(
                                            title: Text(
                                                'Tags are keywords that can be associated with this course.',
                                                style: TextStyle(
                                                    fontFamily: 'RegularText',
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            content: Text(
                                                "Example tags could be: 'Project-heavy', 'Assignment-heavy', 'Labs', 'Exams', etc.",
                                                style: TextStyle(
                                                    fontFamily: 'RegularText',
                                                    fontSize: 14)),
                                          );
                                        });
                                  },
                                )),
                          ],
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: _showEmptyTags
                                ? Text(
                                    'Please add tags to describe your post.',
                                    style: TextStyle(
                                        color: AppColor().textError,
                                        fontSize: 12),
                                  )
                                : null),
                        const SizedBox(height: 16.0),
                        const Text('Difficulty Rating:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'RegularText')),
                        Semantics(
                          label:
                              'Slide to select difficulty rating of this course',
                          slider: true,
                          value: difficultyRating.toString(),
                          liveRegion: true,
                          child: Slider(
                            value: difficultyRating,
                            min: 1,
                            max: 5,
                            divisions: 8,
                            label: difficultyRating.toString(),
                            onChanged: (value) {
                              setState(() => difficultyRating = value);
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: const Text('Overall Course Rating:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'RegularText')),
                            ),
                            Semantics(
                                label:
                                    'Select a star to describe the overall course rating',
                                value: overallRating.toString(),
                                liveRegion: true,
                                child: RatingBar.builder(
                                    initialRating: 2.5,
                                    maxRating: 5,
                                    updateOnDrag: true,
                                    allowHalfRating: true,
                                    itemSize: 40,
                                    itemBuilder: (context, _) {
                                      return Icon(Icons.star_rounded,
                                          color: AppColor().starColorPrimary);
                                    },
                                    onRatingUpdate: (rating) {
                                      setState(() => overallRating = rating);
                                    })),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Semantics(
                          label:
                              'Write your reviews and thoughts about the course here',
                          textField: true,
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            maxLines: 10,
                            decoration: InputDecoration(
                              errorStyle:
                                  TextStyle(color: AppColor().textError),
                              hintText:
                                  'Write your reviews and thoughts about the course here:',
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _validateInputs();
                              setState(() => reviewDetail = value);
                            },
                            onFieldSubmitted: (value) {
                              _validateInputs();
                              setState(() => reviewDetail = value);
                            },
                            validator: (review) {
                              if (review == null || review.isEmpty) {
                                return "Please describe your experience with this course.";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Semantics(
                                label: 'Submit',
                                button: true,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_validateInputs()) {
                                      IndividualCourseReview review = IndividualCourseReview(
                                        reviewerId: FirebaseAuth.instance.currentUser!.uid,
                                        reviewerUsername: FirebaseAuth.instance.currentUser!.displayName!,
                                        courseId: selectedCourse!.courseId!,
                                        instructorId:
                                            selectedInstructor!.instructorId!,
                                        semester: selectedSemester!,
                                        year: selectedYear!,
                                        estimatedWorkload: selectedWorkload!,
                                        grade: selectedGrade!,
                                        tags: _tags,
                                        difficultyRating: difficultyRating,
                                        overallRating: overallRating,
                                        reviewDetail: reviewDetail!,
                                      );
                                      await CourseReviewService()
                                          .addCourseReview(review);
                                      appState.changePages('/successfulreview');
                                    }
                                  },
                                  child: const Text('Submit!'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
