import 'dart:io';

import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/screens/image_screen.dart';
import 'package:edu_nova/screens/subscribers_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/widgets/default_widget.dart';
import 'package:edu_nova/widgets/marked_filter_chip.dart';
import 'package:edu_nova/widgets/course_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class UserChannelScreen extends StatefulWidget {
  const UserChannelScreen({super.key});
  static const routeName = '/user-channel';

  @override
  State<UserChannelScreen> createState() => _UserChannelScreenState();
}

class _UserChannelScreenState extends State<UserChannelScreen> {
  String firstName = '';
  String lastName = '';
  bool isSelected = true;

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
    final Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? email = arguments?['email'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: StreamBuilder(
          stream: Repository.databaseUser.onValue,
          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;

              data.forEach((key, value) {
                if (value['email'].toString() == email) {
                  firstName = value['first_name'];
                  lastName = value['last_name'];
                }
              });

              return Text('$firstName $lastName');
            } else if (snapshot.hasError) {
              return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          },
        ),
        elevation: 0,
        actions: [
          StreamBuilder(
            stream: Repository.databaseUser.onValue,
            builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                final dataListKeys = data.keys.toList();

                for (int index = 0; index < dataListKeys.length; index++) {
                  if (data[dataListKeys[index]]['email'].toString() == email.toString()) {
                    return IconButton(
                      onPressed: () {
                        redirectToWhatsApp(
                          '${data[dataListKeys[index]]['countryCode']}${data[dataListKeys[index]]['phone']}',
                          '${AppLocalizations.of(context)!.hiJustSawYourCourseOnEduNova} \n\n${AppLocalizations.of(context)!.bestRegards}',
                        );
                      },
                      icon: const Icon(Icons.call),
                    );
                  }
                }
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: Repository.databaseUser.onValue,
              builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                  final filteredUsers = data.values.where((user) {
                    final userEmail = user['email'].toString();
                    return userEmail == email;
                  }).toList();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: filteredUsers.map((user) {
                      Widget avatar;
                      if (user['imageUrl'] != null) {
                        avatar = Hero(
                          tag: 'hero-tag-3',
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundColor: kTransparentColor,
                            backgroundImage: NetworkImage(user['imageUrl']),
                          ),
                        );
                      } else {
                        avatar = Hero(
                          tag: 'hero-tag-3',
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
              child: StreamBuilder(
                stream: Repository.databaseUser.onValue,
                builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;

                    String firstName = '';
                    String lastName = '';
                    List<String> interests = [];

                    data.forEach((key, value) {
                      if (value['email'].toString() == email) {
                        firstName = value['first_name'];
                        lastName = value['last_name'];
                        final interestsData = value['interests'];
                        if (interestsData != null && interestsData is List<Object?>) {
                          interests = List<String>.from(interestsData);
                        }
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
                              email!,
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: kTextColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        StreamBuilder(
                          stream: Repository.databaseSubscribe.onValue,
                          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator.adaptive());
                            } else {
                              if (snapshot.data!.snapshot.value != null) {
                                Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                                List<dynamic> sStream = [];
                                sStream.clear();
                                sStream = map.values.where((item) => item['to'] == email).toList();

                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(SubscribersScreen.routeName, arguments: sStream);
                                      },
                                      child: Text(
                                        '${sStream.length} ${AppLocalizations.of(context)!.subscribers}',
                                        style: Theme.of(context).textTheme.labelMedium,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              }
                              return Container();
                            }
                          },
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
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.courses, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: kTextColor)),
              subtitle: Text(AppLocalizations.of(context)!.exploreAdditionalCoursesTaughtByThisExceptionalInstructor, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor)),
            ),
            StreamBuilder(
              stream: Repository.databaseCourse.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                } else {
                  if (snapshot.data!.snapshot.value != null) {
                    Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> stream = [];
                    stream.clear();
                    stream = map.values.toList();

                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context, index) {
                          if (email == stream[index]['email'].toString()) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: 400,
                                  child: CourseCard(course: stream[index]),
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                    );
                  }
                  return DefaultWidget(title: '$firstName $lastName ${AppLocalizations.of(context)!.dontHaveAnyCourseYet}', subtitle: '', icon: Icons.do_not_disturb);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
