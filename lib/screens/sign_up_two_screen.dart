import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/screens/sign_up_three_screen.dart';
import 'package:edu_nova/widgets/multi_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpTwoScreen extends StatefulWidget {
  final String firstName;
  final String lastName;

  const SignUpTwoScreen({super.key, required this.firstName, required this.lastName});

  @override
  State<SignUpTwoScreen> createState() => _SignUpTwoScreenState();
}

class _SignUpTwoScreenState extends State<SignUpTwoScreen> {
  List<String> selectedinterestList = [];

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: size(context).height * 0.6,
                  ),
                  child: Container(
                    width: size(context).width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            AppLocalizations.of(context)!.tellUsAreasOfEducationYoureInterestedIn,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        MultiChipWidget(
                          onSelectionChanged: (selectedList) {
                            selectedinterestList = selectedList;
                          },
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUpThreeScreen(
                                firstName: widget.firstName,
                                lastName: widget.lastName,
                                selectedinterestList: selectedinterestList,
                              ),
                            ),
                          );
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
    );
  }
}
