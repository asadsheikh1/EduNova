import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/screens/user_channel_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubscribersScreen extends StatelessWidget {
  const SubscribersScreen({super.key});
  static const routeName = '/subscribers';

  @override
  Widget build(BuildContext context) {
    final sStream = ModalRoute.of(context)!.settings.arguments as List<dynamic>?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(AppLocalizations.of(context)!.allSubscribers),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (sStream != null)
            ...sStream.map((subscriber) {
              return StreamBuilder(
                stream: Repository.databaseUser.onValue,
                builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
                    final filteredUsers = data.values.where((user) {
                      final email = user['email'].toString();
                      return email == subscriber['from'];
                    }).toList();

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: filteredUsers.map((user) {
                        Widget avatar;
                        if (user['imageUrl'] != null) {
                          avatar = CircleAvatar(
                            backgroundColor: kTransparentColor,
                            backgroundImage: NetworkImage(user['imageUrl']),
                          );
                        } else {
                          avatar = CircleAvatar(
                            backgroundColor: kTransparentColor,
                            backgroundImage: const AssetImage('assets/images/profile.jpg'),
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(UserChannelScreen.routeName, arguments: {'email': subscriber['from']});
                          },
                          child: StreamBuilder(
                            stream: Repository.databaseUser.onValue,
                            builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;

                                String firstName = '';
                                String lastName = '';

                                data.forEach((key, value) {
                                  if (value['email'].toString() == subscriber['from']) {
                                    firstName = value['first_name'];
                                    lastName = value['last_name'];
                                  }
                                });

                                return ListTile(
                                  leading: avatar,
                                  title: Text('$firstName $lastName'),
                                  subtitle: Text(subscriber['from']),
                                );
                              } else if (snapshot.hasError) {
                                return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
                              } else {
                                return const Center(child: CircularProgressIndicator.adaptive());
                              }
                            },
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
            }).toList(),
        ],
      ),
    );
  }
}
