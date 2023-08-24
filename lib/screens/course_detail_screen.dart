import 'dart:convert';
import 'dart:io';

import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/screens/checkout_screen.dart';
import 'package:edu_nova/screens/image_screen.dart';
import 'package:edu_nova/screens/user_channel_screen.dart';
import 'package:edu_nova/screens/video_player_screen.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:edu_nova/widgets/marked_filter_chip.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/course-detail';

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late double xAlign;
  late Color loginColor;
  late Color signInColor;
  bool descriptionShow = false;
  bool isEnrolled = false;
  String? favouriteId;
  bool isFavourite = false;
  String? subscribeId;
  bool isSubscribed = false;
  Map<dynamic, dynamic>? favourites;
  Map<dynamic, dynamic>? subscribers;
  Map<dynamic, dynamic>? transactions;
  TextEditingController callIdController = TextEditingController();
  Map<dynamic, dynamic>? devices;
  String? token;

  @override
  void initState() {
    xAlign = -1;
    loginColor = kLightColor;
    signInColor = kMainSwatchColor;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void redirectToWhatsApp(String phone, String message) async {
    final whatsappUrl = url(phone, message);

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  String url(String phone, String message) {
    if (Platform.isAndroid) {
      return "https://wa.me/$phone/?text=${Uri.parse(message)}";
    } else {
      return "https://api.whatsapp.com/send?phone=$phone&text=${Uri.parse(message)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    List<String> descriptions = [
      AppLocalizations.of(context)!.usersActivelyEngageInDiscussionsAskingQuestionsAndSharingOpinions,
      AppLocalizations.of(context)!.eduNovaOffersDiverseCoursesForSelfPacedLearningAndSkillsInVariousSubjectsThroughEngagingContent,
      AppLocalizations.of(context)!.connectAndInteractWithFellowStudentsEitherThroughMeetupsOrByCallingThemAnytime,
    ];
    Map<String, String> faqs = {
      AppLocalizations.of(context)!.canIEnrollSingleClass: AppLocalizations.of(context)!.yesYouCanEnrollInASingleClass,
      AppLocalizations.of(context)!.canIAccessTheAppOnMultipleDevices: AppLocalizations.of(context)!.yesYouCanAccessTheAppOnMultipleDevices,
      AppLocalizations.of(context)!.canIInteractWithInstructorsOrOtherStudents: AppLocalizations.of(context)!.yesYouCanInteractWithInstructorsAndOtherStudents,
      AppLocalizations.of(context)!.canIAccessTheAppInternationally: AppLocalizations.of(context)!.yesYouCanAccessTheAppInternationally,
    };
    List<String> outlinesList = (course['outline'] as List<Object?>).whereType<String>().toList();
    List<String> interestsList = (course['interests'] as List<Object?>).whereType<String>().toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainSwatchColor,
        title: const Text('EduNova'),
        elevation: 0,
        foregroundColor: kLightColor,
        leading: BackButton(color: kLightColor),
        actions: [
          StreamBuilder<DatabaseEvent>(
            stream: Repository.databaseFavourite.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var dataSnapshot = snapshot.data!.snapshot.value;
                favourites = dataSnapshot as Map<dynamic, dynamic>?;

                if (favourites != null) {
                  favourites!.forEach((key, value) {
                    if (value['email'] == UserCacheData.userEmail && value['courseId'] == course['time']) {
                      favouriteId = value['favouriteId'];
                      isFavourite = true;
                    }
                  });
                }
              } else {
                return const Center(child: CircularProgressIndicator.adaptive());
              }

              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (isFavourite == true && favouriteId != null) {
                        Repository.deleteFavouriteCourse(
                          date: favouriteId!,
                          context: context,
                        );
                        favouriteId = null;
                        isFavourite = false;
                      } else {
                        Repository.addFavouriteCourse(
                          date: DateTime.now().millisecondsSinceEpoch.toString(),
                          courseId: course['time'],
                          context: context,
                        );
                      }
                    },
                    color: kLightColor,
                    icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              height: size(context).height * 0.4,
              width: size(context).width,
              color: kMainSwatchColor,
            ),
            SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: size(context).height * 0.2,
                    width: size(context).width,
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Text(
                          course['title'].toString(),
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: kLightColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(16),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child: Stack(
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/images/logo-light.png',
                          image: course['imageUrl'].toString(),
                          height: 240,
                          width: size(context).width,
                          fit: BoxFit.fitHeight,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      width: size(context).width * 0.8,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: kTransparentColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            alignment: Alignment(xAlign, 0),
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              width: size(context).width * 0.4,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: kMainSwatchColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                xAlign = -1;
                                loginColor = kLightColor;
                                descriptionShow = false;
                                signInColor = kMainSwatchColor;
                              });
                            },
                            child: Align(
                              alignment: const Alignment(-1, 0),
                              child: Container(
                                width: size(context).width * 0.4,
                                color: kTransparentColor,
                                alignment: Alignment.center,
                                child: Text(AppLocalizations.of(context)!.courseCapital, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: loginColor)),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                xAlign = 1;
                                signInColor = kLightColor;
                                descriptionShow = true;
                                loginColor = kMainSwatchColor;
                              });
                            },
                            child: Align(
                              alignment: const Alignment(1, 0),
                              child: Container(
                                width: size(context).width * 0.4,
                                color: kTransparentColor,
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)!.instructor,
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: signInColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: descriptionShow,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                          stream: Repository.databaseUser.onValue,
                          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                              final filteredUsers = data.values.where((user) {
                                final email = user['email'].toString();
                                return email == course['email'];
                              }).toList();

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: filteredUsers.map((user) {
                                  Widget avatar;
                                  if (user['imageUrl'] != null) {
                                    avatar = Hero(
                                      tag: 'hero-tag',
                                      child: CircleAvatar(
                                        radius: 60.0,
                                        backgroundColor: kTransparentColor,
                                        backgroundImage: NetworkImage(user['imageUrl']),
                                      ),
                                    );
                                  } else {
                                    avatar = Hero(
                                      tag: 'hero-tag',
                                      child: CircleAvatar(
                                        radius: 60.0,
                                        backgroundColor: kTransparentColor,
                                        backgroundImage: const AssetImage('assets/images/profile.jpg'),
                                      ),
                                    );
                                  }

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(ImageScreen.routeName, arguments: user['imageUrl']);
                                        },
                                        child: Center(child: avatar),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
                            } else {
                              return const Center(child: CircularProgressIndicator.adaptive());
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                stream: Repository.databaseUser.onValue,
                                builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                                  if (snapshot.hasData) {
                                    final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;

                                    String firstName = '';
                                    String lastName = '';
                                    String email = '';
                                    List<String> interests = [];

                                    data.forEach((key, value) {
                                      if (value['email'].toString() == course['email'].toString()) {
                                        email = value['email'];
                                        firstName = value['first_name'];
                                        lastName = value['last_name'];
                                        interests = (value['interests'] as List<Object?>?)?.cast<String>() ?? [];
                                      }
                                    });

                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ListTile(
                                          title: Center(
                                            child: Text(
                                              '$firstName $lastName',
                                              style: Theme.of(context).textTheme.titleMedium,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          subtitle: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!.name,
                                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: kTextColor),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Center(
                                            child: Text(
                                              email,
                                              style: Theme.of(context).textTheme.titleMedium,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          subtitle: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!.email,
                                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: kTextColor),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Center(
                                            child: MarkedFilterChip(list: interests),
                                          ),
                                          subtitle: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!.hisHerInterests,
                                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: kTextColor),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
                                  } else {
                                    return const Center(child: CircularProgressIndicator.adaptive());
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FilledButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(UserChannelScreen.routeName, arguments: {'email': course['email']});
                                          },
                                          child: Text(AppLocalizations.of(context)!.visitChannel),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: StreamBuilder<DatabaseEvent>(
                                        stream: Repository.databaseSubscribe.onValue,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var dataSnapshot = snapshot.data!.snapshot.value;
                                            subscribers = dataSnapshot as Map<dynamic, dynamic>?;

                                            if (subscribers != null) {
                                              subscribers!.forEach((key, value) {
                                                if (value['from'] == UserCacheData.userEmail && value['to'] == course['email']) {
                                                  subscribeId = value['subscribeId'];
                                                  isSubscribed = true;
                                                }
                                              });
                                            }
                                          } else {
                                            return const Center(child: CircularProgressIndicator.adaptive());
                                          }

                                          return StreamBuilder(
                                              stream: Repository.databaseDevice.onValue,
                                              builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> dSnapshot) {
                                                if (dSnapshot.hasData) {
                                                  return FilledButton(
                                                    onPressed: () async {
                                                      if (isSubscribed == true && subscribeId != null) {
                                                        Repository.deleteSubscribeCourse(
                                                          date: subscribeId!,
                                                          context: context,
                                                        );
                                                        subscribeId = null;
                                                        isSubscribed = false;
                                                      } else {
                                                        Repository.addSubscribeCourse(
                                                          date: DateTime.now().millisecondsSinceEpoch.toString(),
                                                          to: course['email'],
                                                          context: context,
                                                        );

                                                        var dataSnapshot = dSnapshot.data!.snapshot.value;
                                                        devices = dataSnapshot as Map<dynamic, dynamic>?;

                                                        if (devices != null) {
                                                          devices!.forEach((key, value) {
                                                            if (value['email'].toString() == course['email']) {
                                                              token = value['token'];
                                                            }
                                                          });
                                                        }
                                                        var data = {
                                                          'to': token,
                                                          'priority': 'high',
                                                          'notification': {'title': '${UserCacheData.userEmail}: EduNova', 'body': 'Yippey! There\'s a ubscriber', "sound": "jetsons_doorbell"},
                                                          'android': {
                                                            'notification': {
                                                              'notification_count': 23,
                                                            },
                                                          },
                                                          'data': {'type': 'msg', 'id': 'Asad Sheikh'}
                                                        };

                                                        await http.post(
                                                          Uri.parse('https://fcm.googleapis.com/fcm/send'),
                                                          body: jsonEncode(data),
                                                          headers: {
                                                            'Content-Type': 'application/json; charset=UTF-8',
                                                            'Authorization':
                                                                'key=AAAAo-UZAoI:APA91bHoDIgoMqcgwKu17tpMn1U82-Gmf2OLwD2gktGgB-MIbF0UqSSBFswIMlPx2SYXlFTEzArAOU7nyxbBU9LrkaJBdqi-NuLaVXvPdJWhsCayRNctJnjIlfZS3da2jQmx2ZnEfgEn'
                                                          },
                                                        );

                                                        token = '';
                                                      }
                                                    },
                                                    child: Text(isSubscribed == false ? AppLocalizations.of(context)!.subscribe : AppLocalizations.of(context)!.unsubscribe),
                                                  );
                                                } else {
                                                  return const CircularProgressIndicator.adaptive();
                                                }
                                              });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !descriptionShow,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(AppLocalizations.of(context)!.description, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: kTextColor)),
                                subtitle: Text(AppLocalizations.of(context)!.developSkillsAndApplyKnowledgeOnTheRightPlace, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(course['description'], style: Theme.of(context).textTheme.titleMedium),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(AppLocalizations.of(context)!.courseOutline, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: kTextColor)),
                                subtitle: Text(
                                  AppLocalizations.of(context)!.theStructuredOverviewOfTheTopicsLearningObjectivesAndTimeline,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: List.generate(outlinesList.length, (index) {
                                    final outline = outlinesList[index];
                                    return ListTile(
                                      leading: CircleAvatar(child: Text((index + 1).toString())),
                                      title: Text(outline.toString(), style: Theme.of(context).textTheme.titleMedium),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(AppLocalizations.of(context)!.whoThisCourseFor, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: kTextColor)),
                                subtitle: Text(AppLocalizations.of(context)!.peopleHavingInterestIn, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: MarkedFilterChip(list: interestsList),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(AppLocalizations.of(context)!.whatYoullGet, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: kTextColor)),
                                subtitle: Text(
                                  AppLocalizations.of(context)!.diverseCoursesForSelfPacedLearningInteractiveParticipationAndStudentConnections,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: descriptions.map((description) {
                                    return ListTile(
                                      leading: Icon(Icons.check, color: kMainSwatchColor),
                                      title: Text(
                                        description,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              ListTile(
                                title: Text(AppLocalizations.of(context)!.faqs, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: kTextColor)),
                                subtitle: Text(
                                  AppLocalizations.of(context)!.frequentlyAskedQuestions,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: faqs.entries.map((MapEntry<String, String> faq) {
                                    return ExpansionTile(
                                      title: Text(faq.key),
                                      collapsedIconColor: kLightColor,
                                      iconColor: kMainSwatchColor,
                                      textColor: kMainSwatchColor,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            faq.value,
                                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: kTextColor),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    StreamBuilder<DatabaseEvent>(
                                      stream: Repository.databaseTransaction.onValue,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(child: CircularProgressIndicator.adaptive());
                                        } else if (snapshot.hasError) {
                                          return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
                                        } else if (!snapshot.hasData) {
                                          return Text(AppLocalizations.of(context)!.noDataAvailable);
                                        }

                                        var dataSnapshot = snapshot.data!.snapshot.value;
                                        transactions = dataSnapshot as Map<dynamic, dynamic>?;

                                        if (transactions != null) {
                                          transactions!.forEach((key, value) {
                                            if (value['from'] == UserCacheData.userEmail && value['courseId'] == course['time']) {
                                              isEnrolled = true;
                                            }
                                          });
                                        }

                                        if (isEnrolled) {
                                          return Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: FilledButton(
                                                onPressed: () {
                                                  Navigator.of(context).pushNamed(VideoPlayerScreen.routeName, arguments: course);
                                                },
                                                child: FittedBox(child: Text(AppLocalizations.of(context)!.enroll)),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: FilledButton(
                                                onPressed: () {
                                                  Navigator.of(context).pushNamed(CheckoutScreen.routeName, arguments: course);
                                                },
                                                child: FittedBox(child: Text(AppLocalizations.of(context)!.buy)),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
