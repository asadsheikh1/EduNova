import 'package:edu_nova/utils/cache.dart';
import 'package:edu_nova/utils/notification_services.dart';

import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/widgets/circle_tab_indicator.dart';
import 'package:edu_nova/widgets/default_widget.dart';
import 'package:edu_nova/widgets/course_search_delegate_widget.dart';
import 'package:edu_nova/widgets/course_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  Map<dynamic, dynamic>? devices;
  String? token;
  String? id;

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    _initializeDevice();
  }

  Future<void> _initializeDevice() async {
    final value = await notificationServices.getDeviceToken();

    final snapshot = await Repository.databaseDevice.once();
    for (var child in snapshot.snapshot.children) {
      if (child.child('email').value.toString() == UserCacheData.userEmail.toString()) {
        id = child.child('id').value.toString();
        break;
      }
    }

    if (id == null) {
      int date = DateTime.now().millisecondsSinceEpoch;
      Repository.setDevice(
        context: context,
        token: value,
        id: date.toString(),
      );
    } else {
      Repository.setDevice(
        context: context,
        token: value,
        id: id!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Repository.interestsList().length + 1,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // StreamBuilder<DatabaseEvent>(
              //   stream: Repository.databaseDevice.onValue,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(child: CircularProgressIndicator.adaptive());
              //     } else if (snapshot.hasError) {
              //       return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
              //     } else if (!snapshot.hasData) {
              //       return Text(AppLocalizations.of(context)!.noDataAvailable);
              //     }

              //     var dataSnapshot = snapshot.data!.snapshot.value;
              //     devices = dataSnapshot as Map<dynamic, dynamic>?;

              //     if (devices != null) {
              //       devices!.forEach((key, value) {
              //         if (value['email'].toString() == 'hadi@gmail.com') {
              //           token = value['token'];
              //         }
              //       });
              //     }

              //     return FilledButton(
              //       onPressed: () async {
              //         var data = {
              //           'to': token,
              //           'priority': 'high',
              //           'notification': {'title': 'EduNova', 'body': 'This notifications was only sent to Hadi', "sound": "jetsons_doorbell"},
              //           'android': {
              //             'notification': {
              //               'notification_count': 23,
              //             },
              //           },
              //           'data': {'type': 'msg', 'id': 'Asad Sheikh'}
              //         };

              //         await http.post(
              //           Uri.parse('https://fcm.googleapis.com/fcm/send'),
              //           body: jsonEncode(data),
              //           headers: {
              //             'Content-Type': 'application/json; charset=UTF-8',
              //             'Authorization':
              //                 'key=AAAAo-UZAoI:APA91bHoDIgoMqcgwKu17tpMn1U82-Gmf2OLwD2gktGgB-MIbF0UqSSBFswIMlPx2SYXlFTEzArAOU7nyxbBU9LrkaJBdqi-NuLaVXvPdJWhsCayRNctJnjIlfZS3da2jQmx2ZnEfgEn'
              //           },
              //         ).then((value) {
              //           print(value.body.toString());
              //         }).onError((error, stackTrace) {
              //           print(error);
              //         });
              //       },
              //       child: const Text('Send'),
              //     );
              //   },
              // ),
              Card(
                elevation: 0,
                color: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  tileColor: kMainSwatchColor.withOpacity(0.2),
                  title: StreamBuilder(
                    stream: Repository.databaseUser.onValue,
                    builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                        final dataListKeys = data.keys.toList();

                        for (int index = 0; index < dataListKeys.length; index++) {
                          if (data[dataListKeys[index]]['email'].toString() == UserCacheData.userEmail || uncachedEmail == data[dataListKeys[index]]['email'].toString()) {
                            return Text('${AppLocalizations.of(context)!.hey}, ${data[dataListKeys[index]]['first_name']}! 😃👋',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold));
                          }
                        }
                      }
                      return const Center(child: CircularProgressIndicator.adaptive());
                    },
                  ),
                  subtitle: Text(AppLocalizations.of(context)!.findASourceYouWantToLearn, style: Theme.of(context).textTheme.labelLarge),
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: kMainSwatchColor.withOpacity(0.2),
                            ),
                            child: Tooltip(
                              message: AppLocalizations.of(context)!.search,
                              child: IconButton(
                                onPressed: () {
                                  showSearch(
                                    context: context,
                                    delegate: CourseSearchDelegateWidget(),
                                  );
                                },
                                icon: Icon(Icons.search, color: kMainSwatchColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TabBar(
                physics: const ClampingScrollPhysics(),
                indicator: CircleTabIndicator(color: kMainSwatchColor, radius: 2),
                isScrollable: true,
                tabs: [
                  Tab(child: Text(AppLocalizations.of(context)!.recommended, style: Theme.of(context).textTheme.titleSmall)),
                  ...Repository.interestsList().map(
                    (interest) {
                      return Tab(child: Text(interest, style: Theme.of(context).textTheme.titleSmall));
                    },
                  ).toList(),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: Repository.databaseUser.onValue,
                  builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;

                      List<String> interests = [];

                      data.forEach((key, value) {
                        if (value['email'].toString() == UserCacheData.userEmail) {
                          interests = (value['interests'] as List<Object?>?)?.cast<String>() ?? [];
                        }
                      });

                      return StreamBuilder(
                        stream: Repository.databaseCourse.onValue,
                        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator.adaptive());
                          } else {
                            if (snapshot.data!.snapshot.value != null) {
                              Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                              List<dynamic> cStream = [];
                              cStream.clear();
                              cStream = map.values.toList();
                              List<dynamic> matchingStreams = cStream.where((course) => (course["interests"] as List<dynamic>).any((interest) => interests.contains(interest))).toList();

                              return TabBarView(
                                children: [
                                  matchingStreams.isNotEmpty
                                      ? ListView.builder(
                                          physics: const ClampingScrollPhysics(),
                                          itemCount: matchingStreams.length,
                                          itemBuilder: (context, index) {
                                            return CourseCard(course: matchingStreams[index]);
                                          },
                                        )
                                      : cStream.isNotEmpty
                                          ? ListView.builder(
                                              physics: const ClampingScrollPhysics(),
                                              itemCount: cStream.length,
                                              itemBuilder: (context, index) {
                                                return CourseCard(course: cStream[index]);
                                              },
                                            )
                                          : DefaultWidget(
                                              title: AppLocalizations.of(context)!.fastenYourSeatbelts,
                                              subtitle: AppLocalizations.of(context)!.coursesWouldBeArrivingSoon,
                                              icon: Icons.access_time_filled,
                                            ),
                                  ...Repository.interestsList().map((interest) {
                                    bool containsInterest = false;

                                    for (var item in cStream) {
                                      List<dynamic> interests = item['interests'];
                                      if (interests.contains(interest)) {
                                        containsInterest = true;
                                        break;
                                      }
                                    }

                                    if (containsInterest) {
                                      return ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: cStream.length,
                                        itemBuilder: (context, index) {
                                          List<dynamic> interests = cStream[index]['interests'];

                                          if (interests.contains(interest)) {
                                            return CourseCard(course: cStream[index]);
                                          } else {
                                            return Container();
                                          }
                                        },
                                      );
                                    } else {
                                      return DefaultWidget(
                                        title: AppLocalizations.of(context)!.fastenYourSeatbelts,
                                        subtitle: '$interest ${AppLocalizations.of(context)!.coursesWouldBeArrivingSoon}',
                                        icon: Icons.access_time_filled,
                                      );
                                    }
                                  }).toList(),
                                ],
                              );
                            }
                          }
                          return DefaultWidget(
                            title: AppLocalizations.of(context)!.fastenYourSeatbelts,
                            subtitle: AppLocalizations.of(context)!.coursesWillBeArrivingSoon,
                            icon: Icons.access_time_filled,
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
