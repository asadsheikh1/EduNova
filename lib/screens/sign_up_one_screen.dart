import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/screens/sign_up_two_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpOneScreen extends StatefulWidget {
  const SignUpOneScreen({super.key});
  static const routeName = '/sign-up-one';

  @override
  State<SignUpOneScreen> createState() => _SignUpOneScreenState();
}

class _SignUpOneScreenState extends State<SignUpOneScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size(context).width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: size(context).height * 0.4),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              AppLocalizations.of(context)!.youreJustCoupleOfStepsAwayFromJoiningUs,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
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
                          Padding(
                            padding: const EdgeInsets.all(16.0),
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
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.keyboard_arrow_left),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FilledButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignUpTwoScreen(firstName: firstNameController.text, lastName: lastNameController.text),
                                ),
                              );
                            }
                          },
                          child: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                    ],
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
