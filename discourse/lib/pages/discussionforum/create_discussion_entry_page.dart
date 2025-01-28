import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/discussion_entry_firebase.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:discourse/service/discussion_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Page to allow users to create a new Discussion Entry
class CreateDiscussionEntryPage extends StatefulWidget {
  const CreateDiscussionEntryPage({super.key, required this.discussionService});
  final DiscussionService discussionService;

  @override
  State<CreateDiscussionEntryPage> createState() =>
      _CreateDiscussionEntryPageState();
}

class _CreateDiscussionEntryPageState extends State<CreateDiscussionEntryPage> {
  final _formKey = GlobalKey<FormState>();

  String? discussionTitle;
  String? discussionBody;
  bool _showEmptyTags = false;
  final List<String> _tags = [];
  TextEditingController tagFormController = TextEditingController();

  /// Validates user input before submitting
  bool _validateInputs() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      if (_tags.isNotEmpty) {
        setState(() => _showEmptyTags = false);
        return true;
      }
      setState(() => _showEmptyTags = true);
      return false;
    } else {
      if (_tags.isEmpty) {
        setState(() => _showEmptyTags = true);
      } else {
        setState(() => _showEmptyTags = false);
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            DiscourseAppBar(
              parentContext: context,
              pageName: 'Create Discussion',
              isForm: true,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.9,
                maxHeight: screenSize.height * 0.73,
              ),
              child: LayoutBuilder(
                builder: (context, topLevelConstraints) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Semantics(
                              label: 'Post your discussion',
                              button: true,
                              child: ElevatedButton(
                                key: const Key('postDiscussionButton'),
                                onPressed: () async {
                                  if (_validateInputs()) {
                                    DiscussionEntryFirebase entry =
                                        DiscussionEntryFirebase(
                                            userId: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            username: FirebaseAuth.instance
                                                .currentUser!.displayName,
                                            discussionTitle: discussionTitle!,
                                            tags: _tags,
                                            likes: 0,
                                            dislikes: 0,
                                            discussionBody: discussionBody!,
                                            datePosted: DateFormat('MM/dd/yyyy')
                                                .format(DateTime.now()),
                                            replyIds: []);
                                    //send new entry to firebase
                                    await widget.discussionService
                                        .addDiscussionEntry(entry);
                                    appState.navigationPop();
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          AppColor().buttonActive),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Post!',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'RegularText',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Semantics(
                              label:
                                  "Enter the title of your discussion post. Required",
                              textField: true,
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() => discussionTitle = value);
                                },
                                style: const TextStyle(
                                  fontFamily: 'RegularText',
                                  fontSize: 24,
                                ),
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor().textError,
                                    ),
                                  ),
                                  errorStyle: TextStyle(
                                    color: AppColor().textError,
                                  ),
                                  hintText: 'Enter title...',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RegularText',
                                    color: AppColor().textInactive,
                                    fontSize: 24,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter the discussion title";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Container(
                            child: Semantics(
                              label:
                                  'Add tags to your discussion post. Required',
                              textField: true,
                              liveRegion: true,
                              child: TextFormField(
                                key: const Key('tagField'),
                                controller: tagFormController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: _tags.isEmpty
                                      ? 'Add tags (required) +'
                                      : 'Add another tag',
                                  hintStyle: TextStyle(
                                    fontFamily: 'RegularText',
                                    fontSize: 14,
                                    color: AppColor().textInactive,
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  setState(
                                    () => _tags.add(value),
                                  );
                                  tagFormController.clear();
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              children: [
                                Container(
                                  child: _tags.isEmpty
                                      ? null
                                      : Wrap(
                                          children: _tags.map((tag) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  right: 3),
                                              child: Semantics(
                                                label:
                                                    '$tag. Tap to remove this tag',
                                                liveRegion: true,
                                                button: true,
                                                child: Chip(
                                                  label: Text(tag),
                                                  onDeleted: () {
                                                    setState(
                                                      () => _tags.remove(tag),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: _showEmptyTags
                                      ? Text(
                                          'Please add tags to describe your post.',
                                          style: TextStyle(
                                            color: AppColor().textError,
                                            fontSize: 12,
                                          ),
                                        )
                                      : null,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth: topLevelConstraints.maxWidth,
                                      maxHeight:
                                          topLevelConstraints.maxHeight * 0.5),
                                  margin: const EdgeInsets.only(top: 12),
                                  child: Semantics(
                                    label:
                                        'Add body to your discussion post. Required',
                                    textField: true,
                                    child: TextFormField(
                                      expands: true,
                                      onChanged: (value) {
                                        setState(() => discussionBody = value);
                                      },
                                      minLines: null,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        errorStyle: TextStyle(
                                          color: AppColor().textError,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Body text...',
                                        hintStyle: TextStyle(
                                          color: AppColor().textInactive,
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppColor().textError,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Discussion body cannot be empty.";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
