import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/screens/user_channel_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:edu_nova/widgets/course_card.dart';
import 'package:edu_nova/widgets/course_search_delegate_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});
  static const routeName = '/subscriptions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
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
                                  return Text('${data[dataListKeys[index]]['first_name']}\'s ${AppLocalizations.of(context)!.favourites}! ❤️',
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold));
                                }
                              }
                            }
                            return const Center(child: CircularProgressIndicator.adaptive());
                          },
                        ),
                        subtitle: Text(AppLocalizations.of(context)!.markAsFavoritesForFuture, style: Theme.of(context).textTheme.labelLarge),
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
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.subscriptions, style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Text(AppLocalizations.of(context)!.youWillReceiveNotificationsFromTheseChannels, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor)),
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
                            sStream = map.values.where((item) => item['from'] == UserCacheData.userEmail).toList();

                            return SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                children: [
                                  ...sStream.map((subscriber) {
                                    return StreamBuilder(
                                      stream: Repository.databaseUser.onValue,
                                      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                                        if (snapshot.hasData) {
                                          final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                                          final filteredUsers = data.values.where((user) {
                                            final email = user['email'].toString();
                                            return email == subscriber['to'];
                                          }).toList();

                                          return Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: filteredUsers.map((user) {
                                              Widget avatar;
                                              if (user['imageUrl'] != null) {
                                                avatar = CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundColor: kTransparentColor,
                                                  backgroundImage: NetworkImage(user['imageUrl']),
                                                );
                                              } else {
                                                avatar = CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundColor: kTransparentColor,
                                                  backgroundImage: const AssetImage('assets/images/profile.jpg'),
                                                );
                                              }

                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(UserChannelScreen.routeName, arguments: {'email': subscriber['to']});
                                                  },
                                                  child: StreamBuilder(
                                                    stream: Repository.databaseUser.onValue,
                                                    builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                                                      if (snapshot.hasData) {
                                                        final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;

                                                        String firstName = '';
                                                        String lastName = '';

                                                        data.forEach((key, value) {
                                                          if (value['email'].toString() == subscriber['to']) {
                                                            firstName = value['first_name'];
                                                            lastName = value['last_name'];
                                                          }
                                                        });

                                                        return ListTile(
                                                          leading: avatar,
                                                          title: Text('$firstName $lastName'),
                                                          subtitle: Text(subscriber['to']),
                                                        );
                                                      } else if (snapshot.hasError) {
                                                        return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
                                                      } else {
                                                        return const Center(child: CircularProgressIndicator.adaptive());
                                                      }
                                                    },
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
                                        } else {
                                          return const Center(child: CircularProgressIndicator.adaptive());
                                        }
                                      },
                                    );
                                  }).toList()
                                ],
                              ),
                            );
                          }
                          return Container();
                        }
                      },
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.favourites, style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Text(AppLocalizations.of(context)!.listingPreferredCoursesForEasyReference, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor)),
                    ),
                    StreamBuilder(
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

                            return StreamBuilder(
                              stream: Repository.databaseFavourite.onValue,
                              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(child: CircularProgressIndicator.adaptive());
                                } else {
                                  if (snapshot.data!.snapshot.value != null) {
                                    Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                                    List<dynamic> fStream = [];
                                    fStream.clear();
                                    fStream = map.values.where((item) => item['email'] == UserCacheData.userEmail).toList();

                                    return SingleChildScrollView(
                                      physics: const ClampingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          ...cStream.map((course) {
                                            return Row(
                                              children: [
                                                ...fStream.map((favourite) {
                                                  if (course['time'] == favourite['courseId']) {
                                                    return SizedBox(
                                                      width: 400,
                                                      child: CourseCard(course: course),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                }).toList(),
                                              ],
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    );
                                  }
                                  return Container();
                                }
                              },
                            );
                          }
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/banner-ad.png',
                scale: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
