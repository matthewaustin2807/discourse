import 'dart:io';

import 'package:discourse/components/discourseAppBar.dart';
import 'package:discourse/constants/appColor.dart';
import 'package:discourse/model/firebase_model/market_page_item_firebase.dart';
import 'package:discourse/model/tag.dart';
import 'package:discourse/service/market_item_service.dart';
import 'package:discourse/service/upload_service.dart';
import 'package:discourse/state/application_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:provider/provider.dart';

/// Page to allow users to create new market listing
class CreateMarketListingPage extends StatefulWidget {
  const CreateMarketListingPage({super.key, required this.fileUploadService, required this.marketPageItemService});
  final MarketPageItemService marketPageItemService;
  final FileUploadService fileUploadService;

  @override
  State<CreateMarketListingPage> createState() =>
      _CreateMarketListingPageState();
}

enum ItemCondition { brandNew, used }

class _CreateMarketListingPageState extends State<CreateMarketListingPage> {
  XFile? _image;
  List<File> _documentsUploaded = [];

  final picker = ImagePicker();
  String? _listingName;
  String? _itemCondition;
  String? _listingDescription;
  final List<Tag> _tags = [];
  bool _showConditionError = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController tagFormController = TextEditingController();

  /// Validates the user inputs
  bool _validateInputs() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (_itemCondition != null) {
        return true;
      } else {
        setState(() => _showConditionError = true);
        return false;
      }
    } else {
      if (_itemCondition == null) {
        setState(() => _showConditionError = true);
      }
    }
    return false;
  }

  /// Gets an image from the device gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      }
    });
  }

  /// Show options to open user gallery
  Future showOptions() async {
    showAdaptiveActionSheet(
      context: context,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: const Text('Choose from gallery'),
            onPressed: (context) {
              getImageFromGallery();
              Navigator.of(context).pop();
            }),
      ],
      cancelAction: CancelAction(title: const Text('Cancel')),
      isDismissible: true,
    );
  }

  /// Uploads listing to Firestore
  Future<void> _uploadAndSaveListing(ApplicationState appState) async {
    try {
      String imageLink = '';
      if (_image != null) {
        imageLink = await FileUploadService().uploadImage(_image!);
      }

      List<String> fileUrls = [];
      if (_documentsUploaded.isNotEmpty) {
        for (var document in _documentsUploaded) {
          String fileUrl = await widget.fileUploadService.uploadFile(document);
          fileUrls.add(fileUrl);
        }
      }

      MarketPageItemFirebase item = MarketPageItemFirebase(
        id: '', 
        listerId: FirebaseAuth.instance.currentUser!.uid,
        listerName: FirebaseAuth.instance.currentUser!.displayName ?? FirebaseAuth.instance.currentUser!.uid,
        imageLink: imageLink,
        itemName: _listingName!,
        itemCondition: _itemCondition!,
        itemDescription: _listingDescription!,
        tags: _tags.map((tag) => tag.tagDescription).toList(),
        fileUrls: fileUrls.isNotEmpty ? fileUrls : null, 
      );

      await widget.marketPageItemService.addItem(item);
      
      appState.navigationPop();
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Listing posted successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error uploading item: $e")));
    }
  }

  /// Gets files from the user's device
  Future getFilesFromMobile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'pdf', 'doc', 'txt'],
  );
  if (result != null) {
    setState(() {
      _documentsUploaded = result.files.map((file) {
        return File(file.path!);
      }).toList();
    });
  }
}


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return Center(
      child: ListView(
        children: [
          DiscourseAppBar(
            parentContext: context,
            pageName: 'Create Listing',
            isForm: true,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
              constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.9,
                  maxHeight: screenSize.height * 0.73),
              child: LayoutBuilder(builder: (context, topLevelConstraints) {
                return SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(
                      width: topLevelConstraints.maxWidth,
                      child: Semantics(
                          label: 'Tap to add picture',
                          button: true,
                          child: GestureDetector(
                            onTap: showOptions,
                            child: SizedBox(
                              width: topLevelConstraints.maxWidth / 2,
                              child: _image == null
                                  ? const Icon(Icons.add, size: 90)
                                  : Image.file(
                                      File(_image!.path),
                                      width: 125,
                                      height: 125,
                                    ),
                            ),
                          )),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ExcludeSemantics(
                                  child: Text('Listing Name: ',
                                      style: TextStyle(
                                          fontFamily: 'RegularText',
                                          fontSize: 18)),
                                ),
                                Semantics(
                                    label: 'Enter a name for this listing',
                                    textField: true,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          _listingName = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          helperText: '*Required',
                                          hintText:
                                              'Enter name for this listing',
                                          hintStyle: TextStyle(
                                              color: AppColor().textInactive),
                                          errorStyle: TextStyle(
                                              color: AppColor().textError)),
                                      autocorrect: false,
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the listing name:';
                                        }
                                        return null;
                                      },
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: topLevelConstraints.maxWidth,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Semantics(
                                  label: 'Select an item condition:',
                                  child: const Text('Condition: ',
                                      style: TextStyle(
                                          fontFamily: 'RegularText',
                                          fontSize: 18)),
                                ),
                                Flexible(
                                  child: Semantics(
                                    label: 'Tap to select new',
                                    button: true,
                                    child: RadioListTile(
                                        title: const Text("New", style: TextStyle(fontSize: 14),),
                                        key: Key("new"),
                                        value: 'new',
                                        groupValue: _itemCondition,
                                        onChanged: (String? value) {
                                          setState(
                                              () => _itemCondition = value);
                                        }),
                                  ),
                                ),
                                Flexible(
                                  child: Semantics(
                                    label: 'Tap to select used',
                                    button: true,
                                    child: RadioListTile(
                                        title: const Text("Used", style: TextStyle(fontSize: 14),),
                                        key: Key("used"),
                                        value: 'used',
                                        groupValue: _itemCondition,
                                        onChanged: (String? value) {
                                          setState(
                                              () => _itemCondition = value);
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: _showConditionError
                                  ? Text(
                                      'Please select an item condition.',
                                      style: TextStyle(
                                          color: AppColor().textError,
                                          fontSize: 12),
                                    )
                                  : null),
                          Container(
                            child: Row(
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
                                              key: Key("tag text field"),
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
                                                      setState(
                                                          () => _tags.add(new Tag(tagDescription: newTag)));
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
                                      icon: Icon(Icons.info_outline_rounded),
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
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 16),
                            child: _tags.isEmpty
                                ? null
                                : Wrap(
                                    children: _tags.map((tag) {
                                      return Semantics(
                                          label: tag.tagDescription,
                                          liveRegion: true,
                                          child: Chip(
                                            label: Text(tag.tagDescription),
                                            onDeleted: () {
                                              setState(() => _tags.remove(tag));
                                            },
                                          ));
                                    }).toList(),
                                  ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ExcludeSemantics(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text('Description: ',
                                        style: TextStyle(
                                            fontFamily: 'RegularText',
                                            fontSize: 18)),
                                  ),
                                ),
                                Semantics(
                                  label: 'Enter a description for your listing',
                                  textField: true,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    maxLines: 10,
                                    decoration: InputDecoration(
                                        helperText: '*Required',
                                        hintText:
                                            'Enter a description for your listing',
                                        hintStyle: TextStyle(
                                            color: AppColor().textInactive),
                                        errorStyle: TextStyle(
                                            color: AppColor().textError),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 0.5)),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColor().textError))),
                                    onChanged: (value) {
                                      setState(
                                          () => _listingDescription = value);
                                    },
                                    autocorrect: false,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the listing description:';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Semantics(
                              label: 'Upload your files by clicking here',
                              button: true,
                              child: TextButton(
                                onPressed: () {
                                  getFilesFromMobile();
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.file_upload_outlined, size: 32),
                                    Text(
                                      _documentsUploaded.isNotEmpty ? 'Upload another file' : 'Upload your files',
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (_documentsUploaded.isNotEmpty) 
                            ..._documentsUploaded.map((file) {
                              return ListTile(
                                title: Text(file.path.split('/').last),
                              );
                            }).toList(),
                          Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Container(
                              alignment: Alignment.bottomRight,
                              margin: const EdgeInsets.only(top: 8),
                              child: Semantics(
                                label: 'Post your listing',
                                button: true,
                                child: ElevatedButton(
                                  key: const Key('postListing'),
                                  onPressed: () {
                                    if (_validateInputs()) {
                                      _uploadAndSaveListing(appState);
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            AppColor().buttonActive),
                                    shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
              })),
        ],
      ),
    );
  }
}
