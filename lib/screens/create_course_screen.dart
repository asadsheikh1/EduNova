import 'dart:io';

import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/widgets/multi_chip_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});
  static const routeName = '/create-course';

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController outlineController = TextEditingController();
  TextEditingController costController = TextEditingController();

  bool showSpinner = false;

  List<String> selectedinterestList = [];
  List<String> outlineList = [];
  File? image;
  final picker = ImagePicker();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    outlineController.dispose();
    costController.dispose();
    super.dispose();
  }

  void clear() {
    outlineController.clear();
    descriptionController.clear();
    outlineController.clear();
    costController.clear();
    setState(() {
      selectedinterestList.clear();
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        flutterToast(AppLocalizations.of(context)!.noFileSelected);
      }
    });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        flutterToast(AppLocalizations.of(context)!.noFileSelected);
      }
    });
  }

  void dialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    getImageCamera();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.camera, color: kMainSwatchColor),
                    title: Text(AppLocalizations.of(context)!.camera),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getImageGallery();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.photo_library, color: kMainSwatchColor),
                    title: Text(AppLocalizations.of(context)!.gallery),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PlatformFile> selectedVideos = [];

  Future<void> pickVideos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        selectedVideos = result.files;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(AppLocalizations.of(context)!.createCourse),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size(context).width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.pleaseEnterCourseTitle;
                                }
                                return null;
                              },
                              controller: titleController,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.courseTitle,
                                floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                                hintStyle: TextStyle(color: kTextColor),
                                labelStyle: TextStyle(color: kTextColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.pleaseEnterCourseDescription;
                                }
                                return null;
                              },
                              controller: descriptionController,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.courseDescription,
                                floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                                hintStyle: TextStyle(color: kTextColor),
                                labelStyle: TextStyle(color: kTextColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                alignLabelWithHint: true,
                              ),
                              maxLines: 3,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || !RegExp(r'^(\d{1,5}|\d{0,5}\.\d{1,2})$').hasMatch(value)) {
                                  return AppLocalizations.of(context)!.enterPrice;
                                } else {
                                  return null;
                                }
                              },
                              controller: costController,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.pricePKR,
                                floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                                hintStyle: TextStyle(color: kTextColor),
                                labelStyle: TextStyle(color: kTextColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.uploadVideos, style: Theme.of(context).textTheme.titleMedium),
                            trailing: IconButton(onPressed: pickVideos, icon: Icon(Icons.upload, color: kMainSwatchColor)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ...selectedVideos.map((videoFile) {
                                return ListTile(
                                  title: Text(videoFile.name, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Text('${videoFile.size} ${AppLocalizations.of(context)!.bytes}'),
                                );
                              }).toList(),
                            ],
                          ),
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.addOutline, style: Theme.of(context).textTheme.titleMedium),
                            subtitle: Text(AppLocalizations.of(context)!.anOutlineProvidesAnOverviewOfTheTopicsConcepts, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor)),
                            trailing: IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0),
                                    ),
                                  ),
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (ctx) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                      left: 16.0,
                                      right: 16.0,
                                      top: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return AppLocalizations.of(context)!.pleaseEnterCourseTitle;
                                              }
                                              return null;
                                            },
                                            controller: outlineController,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              labelText: AppLocalizations.of(context)!.outline,
                                              floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                                              hintStyle: TextStyle(color: kTextColor),
                                              labelStyle: TextStyle(color: kTextColor),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20),
                                                borderSide: const BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                              filled: true,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: SizedBox(
                                            width: size(context).width,
                                            child: FilledButton(
                                              child: Text(AppLocalizations.of(context)!.add),
                                              onPressed: () {
                                                setState(() {
                                                  outlineList.add(outlineController.text);
                                                });
                                                flutterToast(AppLocalizations.of(context)!.outlineAddedSuccessfully);
                                                outlineController.clear();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.add,
                                color: kMainSwatchColor,
                              ),
                            ),
                          ),
                          ...outlineList.map(
                            (outline) {
                              return GestureDetector(
                                onLongPress: () {
                                  AlertDialog alert = AlertDialog(
                                    title: Text(AppLocalizations.of(context)!.delete),
                                    content: Text("${AppLocalizations.of(context)!.areYouSureYouWantToDelete} '$outline' ${AppLocalizations.of(context)!.outlineQuestionMark}"),
                                    actions: [
                                      SizedBox(
                                        child: FilledButton(
                                          child: Text(AppLocalizations.of(context)!.cancel),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        child: FilledButton(
                                          child: Text(AppLocalizations.of(context)!.remove),
                                          onPressed: () {
                                            setState(() {
                                              outlineList.remove(outline);
                                            });
                                            flutterToast(AppLocalizations.of(context)!.outlineRemovedSuccessfully);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                },
                                child: ListTile(
                                  title: Text(outline, style: Theme.of(context).textTheme.titleSmall),
                                ),
                              );
                            },
                          ).toList(),
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.selectCategories, style: Theme.of(context).textTheme.titleMedium),
                            subtitle: Text(AppLocalizations.of(context)!.forBetterReachChooseUpto3, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor)),
                          ),
                          MultiChipWidget(
                            onSelectionChanged: (selectedList) {
                              setState(() {
                                selectedinterestList = selectedList;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.uploadImage, style: Theme.of(context).textTheme.titleMedium),
                            subtitle: Text(AppLocalizations.of(context)!.thisImageWillServeAsAPreviewOrVisualRepresentationOfAVideo,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor)),
                            trailing: IconButton(
                              onPressed: () {
                                dialog(context);
                              },
                              icon: Icon(Icons.image, color: kMainSwatchColor),
                            ),
                          ),
                          image != null
                              ? ClipRect(
                                  child: Image.file(
                                    image!.absolute,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fitWidth,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(color: kMainSwatchColor.shade50),
                                  height: 100,
                                  width: 100,
                                  child: Icon(
                                    Icons.image,
                                    color: kLightColor,
                                  ),
                                )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: size(context).width,
                        child: FilledButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (selectedVideos.isNotEmpty) {
                                if (outlineList.isNotEmpty) {
                                  if (selectedinterestList.isNotEmpty) {
                                    if (image != null) {
                                      setState(() {
                                        showSpinner = true;
                                      });

                                      List<String> videoUrl = [];

                                      try {
                                        FirebaseStorage storage = FirebaseStorage.instance;
                                        for (int i = 0; i < selectedVideos.length; i++) {
                                          PlatformFile videoFile = selectedVideos[i];
                                          String fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.mp4';
                                          Reference storageRef = storage.ref().child('videos/$fileName');
                                          TaskSnapshot snapshot = await storageRef.putFile(File(videoFile.path!));
                                          videoUrl.add(await snapshot.ref.getDownloadURL());
                                        }

                                        int date = DateTime.now().millisecondsSinceEpoch;
                                        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/thumbnails/$date.jpeg');
                                        UploadTask uploadTask = ref.putFile(image!.absolute);
                                        TaskSnapshot snapshot = await uploadTask;
                                        String imageUrl = await snapshot.ref.getDownloadURL();

                                        // ignore: use_build_context_synchronously
                                        Repository.setCourseData(
                                          context: context,
                                          title: titleController.text,
                                          description: descriptionController.text,
                                          outline: outlineList,
                                          cost: costController.text,
                                          interests: selectedinterestList,
                                          date: date,
                                          imageUrl: imageUrl,
                                          videoUrl: videoUrl,
                                        );
                                        clear();
                                      } catch (e) {
                                        setState(() {
                                          showSpinner = false;
                                        });
                                        flutterToast(e.toString());
                                      }
                                    } else {
                                      flutterToast(AppLocalizations.of(context)!.pleaseChooseAnImage);
                                    }
                                  } else {
                                    flutterToast(AppLocalizations.of(context)!.pleaseSelectAtleastOneCategory);
                                  }
                                } else {
                                  flutterToast(AppLocalizations.of(context)!.pleaseAddAtleastOneOutline);
                                }
                              } else {
                                flutterToast(AppLocalizations.of(context)!.pleaseSelectAtleastOneVideo);
                              }
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.create),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
