import 'dart:io';

import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const routeName = '/edit-profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryISOCodeController = TextEditingController();
  Function(List<String>)? onSelectionChanged;
  Function(List<String>)? onMaxSelected;
  List<String> interestList = Repository.interestsList();
  List<String> selectedChoices = [];

  File? image;
  final picker = ImagePicker();

  List<Widget> _buildChoiceList() {
    List<Widget> choices = [];

    for (var item in interestList) {
      choices.add(
        Container(
          padding: const EdgeInsets.all(2.0),
          child: FilterChip(
            label: Text(
              item,
              style: selectedChoices.contains(item) ? Theme.of(context).textTheme.titleSmall!.copyWith(color: kLightColor) : Theme.of(context).textTheme.titleSmall!.copyWith(color: kDarkColor),
            ),
            checkmarkColor: kLightColor,
            selectedColor: kMainSwatchColor,
            selected: selectedChoices.contains(item),
            onSelected: (selected) {
              if (selectedChoices.length == (interestList.length) && !selectedChoices.contains(item)) {
                onMaxSelected?.call(selectedChoices);
              } else {
                setState(() {
                  selectedChoices.contains(item) ? selectedChoices.remove(item) : selectedChoices.add(item);
                  onSelectionChanged?.call(selectedChoices);
                });
              }
            },
          ),
        ),
      );
    }
    return choices;
  }

  @override
  void initState() {
    super.initState();
    Repository.databaseUser.onValue.listen((event) {
      for (var child in event.snapshot.children) {
        if (child.child('email').value.toString() == UserCacheData.userEmail.toString()) {
          firstNameController.text = child.child('first_name').value.toString();
          lastNameController.text = child.child('last_name').value.toString();
          countryCodeController.text = child.child('countryCode').value.toString();
          phoneController.text = child.child('phone').value.toString();
          countryISOCodeController = TextEditingController(text: child.child('countryISOCode').value.toString());
        }
      }
    });

    Repository.databaseUser.onValue.listen((event) {
      for (DataSnapshot child in event.snapshot.children) {
        if (child.key == UserCacheData.userId.toString()) {
          List<Object?>? interests = child.child('interests').value as List<Object?>?;
          if (interests != null) {
            if (mounted) {
              setState(() {
                selectedChoices = interests.cast<String>().toList();
              });
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(AppLocalizations.of(context)!.editProfile),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: Repository.databaseUser.onValue,
                        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                            final filteredUsers = data.values.where((user) {
                              final email = user['email'].toString();
                              return email == UserCacheData.userEmail || uncachedEmail == email;
                            }).toList();

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...filteredUsers.map(
                                  (user) => GestureDetector(
                                    onLongPress: () => dialog(context),
                                    child: image == null && user['imageUrl'] == null
                                        ? const CircleAvatar(
                                            radius: 60.0,
                                            backgroundImage: AssetImage('assets/images/profile.jpg'),
                                          )
                                        : image == null && user['imageUrl'] != null
                                            ? Hero(
                                                tag: 'hero-tag',
                                                child: CircleAvatar(
                                                  radius: 60.0,
                                                  backgroundColor: kTransparentColor,
                                                  backgroundImage: NetworkImage(user['imageUrl']),
                                                ),
                                              )
                                            : Hero(
                                                tag: 'hero-tag',
                                                child: CircleAvatar(
                                                  radius: 60.0,
                                                  backgroundImage: Image.file(image!.absolute).image,
                                                ),
                                              ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...filteredUsers.map((user) => Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${user['first_name']} ${user['last_name']}',
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          user['email'].toString(),
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                      ],
                                    )),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
                          } else {
                            return const Center(child: CircularProgressIndicator.adaptive());
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.pleaseEnterFirstName;
                            }
                            return null;
                          },
                          controller: firstNameController,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.firstName,
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
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.pleaseEnterLastName;
                            }
                            return null;
                          },
                          controller: lastNameController,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.lastName,
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
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.toString() == '') {
                              return AppLocalizations.of(context)!.pleaseFillTheInfo;
                            } else {
                              return null;
                            }
                          },
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.phone,
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
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.interests,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.tellUsYourInterests,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor),
                        ),
                      ),
                      Wrap(
                        children: _buildChoiceList(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: size(context).width,
                      child: FilledButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (image != null) {
                              try {
                                int date = DateTime.now().millisecondsSinceEpoch;

                                firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/avatars/$date');
                                UploadTask uploadTask = ref.putFile(image!.absolute);
                                TaskSnapshot snapshot = await uploadTask;
                                await snapshot.ref.getDownloadURL().then((value) {
                                  Repository.updateUserData(
                                    context: context,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    interests: selectedChoices,
                                    imageUrl: value,
                                    countryCode: countryCodeController.text,
                                    phone: phoneController.text,
                                    countryISOCode: countryISOCodeController.text,
                                  );
                                });
                              } catch (e) {
                                flutterToast(AppLocalizations.of(context)!.unsupportedFileTypeOrSize);
                              }
                            } else {
                              Repository.updateUserDataWithoutImage(
                                context: context,
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                interests: selectedChoices,
                                countryCode: countryCodeController.text,
                                phone: phoneController.text,
                                countryISOCode: countryISOCodeController.text,
                              );
                            }
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.submit),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
