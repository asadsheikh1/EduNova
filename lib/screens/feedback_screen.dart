import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  static const routeName = '/feedback';

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController feedbackController = TextEditingController();
  bool isSwitched = false;
  int feedbackRating = 0;

  void clear() {
    feedbackController.clear();
  }

  @override
  void initState() {
    UserCacheData.getCacheData();
    super.initState();
  }

  @override
  void dispose() {
    feedbackController.dispose();
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(AppLocalizations.of(context)!.feedback),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const ClampingScrollPhysics(),
          child: Container(
            height: size(context).height * 0.8,
            width: size(context).width,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: Repository.databaseUser.onValue,
                    builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                        final dataListKeys = data.keys.toList();

                        return SizedBox(
                          height: size(context).height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int index = 0; index < dataListKeys.length; index++)
                                if (data[dataListKeys[index]]['email'].toString() == UserCacheData.userEmail || uncachedEmail == data[dataListKeys[index]]['email'].toString())
                                  Text(
                                    '${data[dataListKeys[index]]['first_name']}! ${AppLocalizations.of(context)!.iNeedYourFeedbackBecauseApparentlyMyAppsScriptNeedsSomeMajorRewrites}',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                            ],
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator.adaptive());
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: size(context).height * 0.15,
                      width: size(context).width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        scrollPhysics: const ClampingScrollPhysics(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseGiveFeedback;
                          }
                          return null;
                        },
                        controller: feedbackController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.whatDoYouLikeMostAboutOurWork,
                          hintStyle: TextStyle(color: kTextColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                        ),
                        maxLines: 5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: EmojiFeedback(
                      customLabels: [
                        AppLocalizations.of(context)!.terrible,
                        AppLocalizations.of(context)!.bad,
                        AppLocalizations.of(context)!.good,
                        AppLocalizations.of(context)!.veryGood,
                        AppLocalizations.of(context)!.awesome,
                      ],
                      labelTextStyle: Theme.of(context).textTheme.labelMedium,
                      animDuration: const Duration(milliseconds: 300),
                      curve: Curves.bounceIn,
                      inactiveElementScale: .5,
                      onChanged: (value) {
                        feedbackRating = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: size(context).width,
                      child: FilledButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (feedbackRating > 0) {
                              Repository.setFeedbackData(
                                feedback: feedbackController.text,
                                rating: feedbackRating,
                                context: context,
                              );
                              clear();
                            } else {
                              flutterToast(AppLocalizations.of(context)!.whatDoYouLikeMostAboutOurWork);
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
