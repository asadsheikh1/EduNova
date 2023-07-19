import 'package:edu_nova/screens/edit_profile_screen.dart';
import 'package:edu_nova/screens/feedback_screen.dart';
import 'package:edu_nova/screens/image_screen.dart';
import 'package:edu_nova/screens/my_course_screen.dart';
import 'package:edu_nova/screens/notifications_screen.dart';
import 'package:edu_nova/screens/settings_screen.dart';
import 'package:edu_nova/screens/subscribers_screen.dart';
import 'package:edu_nova/widgets/profile_options.dart';
import 'package:flutter/material.dart';
import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    UserCacheData.getCacheData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
            width: size(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: (size(context).height) * 0.28,
                    minHeight: (size(context).height) * 0.28,
                  ),
                  child: StreamBuilder(
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      ImageScreen.routeName,
                                      arguments: user['imageUrl'],
                                    );
                                  },
                                  child: avatar,
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  '${user['first_name']} ${user['last_name']}',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  user['email'].toString(),
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 20.0),
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
                                        sStream = map.values.where((item) => item['to'] == user['email']).toList();

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
                                          ],
                                        );
                                      }
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${AppLocalizations.of(context)!.error} ${snapshot.error}');
                      } else {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Column(
                  children: [
                    ProfileOptions(
                      title: AppLocalizations.of(context)!.editProfile,
                      icon: Icons.person,
                      onTap: () {
                        Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                      },
                    ),
                    ProfileOptions(
                      title: AppLocalizations.of(context)!.myCourse,
                      icon: Icons.menu_book_rounded,
                      onTap: () {
                        Navigator.of(context).pushNamed(MyCourseScreen.routeName);
                      },
                    ),
                    ProfileOptions(
                      title: AppLocalizations.of(context)!.notifications,
                      icon: Icons.notification_add,
                      onTap: () {
                        Navigator.of(context).pushNamed(NotificationsScreen.routeName);
                      },
                    ),
                    ProfileOptions(
                      title: AppLocalizations.of(context)!.settings,
                      icon: Icons.settings,
                      onTap: () {
                        Navigator.of(context).pushNamed(SettingsScreen.routeName);
                      },
                    ),
                    ProfileOptions(
                      title: AppLocalizations.of(context)!.feedback,
                      icon: Icons.feedback,
                      onTap: () {
                        Navigator.of(context).pushNamed(FeedbackScreen.routeName);
                      },
                    ),
                    ProfileOptions(
                      title: AppLocalizations.of(context)!.logout,
                      icon: Icons.logout,
                      onTap: () {
                        Repository.logout(context);
                      },
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
