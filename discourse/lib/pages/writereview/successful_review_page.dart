import 'package:discourse/constants/appColor.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Page to be shown to the user upon successfully submitting a course review.
class SuccessfulReviewPage extends StatelessWidget {
  const SuccessfulReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState applicationState =
        Provider.of<ApplicationState>(context, listen: false);

    return Center(
      child: Container(
        constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.92,
            maxHeight: screenSize.height * 0.7),
        margin: const EdgeInsets.only(top: 64),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColor().tertiary,
            border: Border.all(color: AppColor().borderColor)),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              ExcludeSemantics(
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: Image.asset('assets/logos/discourse_logo.png')),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                padding: const EdgeInsets.all(21),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor().lightPurple,
                    border: Border.all(color: AppColor().borderColor)),
                child: MergeSemantics(                
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: const Text('Congratulations!',
                              style: TextStyle(
                                  fontFamily: 'RegularText',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold))),
                      Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Your Review Has Been Published!',
                            style: TextStyle(
                                fontFamily: 'RegularText',
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.8,
                  ),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'It is now visible to other students and instructors.',
                    style: TextStyle(fontFamily: 'RegularText', fontSize: 14),
                    textAlign: TextAlign.right,
                  )),
              Container(
                margin: const EdgeInsets.only(top: 96),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth * 0.45),
                        child: Semantics(
                          button: true,
                          label: 'Go back to homepage',
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)))),
                            onPressed: () {
                              applicationState.changePages('/homepage');
                            },
                            child: const Text(
                              'Take me back to the homepage',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: constraints.maxWidth * 0.45),
                      child: Semantics(
                        button: true,
                        label: 'Go to my reviews',
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)))),
                            onPressed: () {
                              applicationState.changePages('/myreviews');
                            },
                            child: const Text(
                              'View my Review History',
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
