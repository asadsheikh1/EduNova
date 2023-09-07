import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/screens/user_chat_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSearchDelegateWidget extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: Theme.of(context).appBarTheme.copyWith(elevation: 0),
      inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
            border: InputBorder.none,
            hintStyle: Theme.of(context).textTheme.titleMedium,
          ),
      textTheme: Theme.of(context).textTheme.copyWith(),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.cancel_rounded, color: kMainSwatchColor),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.chevron_left, color: kMainSwatchColor),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: Repository.databaseUser.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else {
          if (snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
            List<dynamic> stream = [];
            stream.clear();
            stream = map.values.toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: snapshot.data!.snapshot.children.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(UserChatScreen.routeName, arguments: {
                      'user': stream[index],
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: stream[index]['imageUrl'] != null
                          ? NetworkImage(
                              stream[index]['imageUrl'].toString(),
                              scale: 5,
                            )
                          : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                    ),
                    title: Text('${stream[index]['first_name']} ${stream[index]['last_name']}'),
                  ),
                );
              },
            );
          }
          return Center(child: Text(AppLocalizations.of(context)!.noCoursesToShow));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: Repository.databaseUser.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else {
          if (snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
            List<dynamic> stream = [];
            stream.clear();
            stream = map.values.toList();

            final List<dynamic> filteredUsers = stream.where((user) {
              final String title = '${user['first_name']} ${user['last_name']}'.toString().toLowerCase();
              final String queryText = query.toLowerCase();
              return title.contains(queryText);
            }).toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(UserChatScreen.routeName, arguments: {
                      'user': filteredUsers[index],
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: filteredUsers[index]['imageUrl'] != null
                          ? NetworkImage(
                              filteredUsers[index]['imageUrl'].toString(),
                              scale: 5,
                            )
                          : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                    ),
                    title: Text('${stream[index]['first_name']} ${stream[index]['last_name']}'),
                  ),
                );
              },
            );
          }
          return Center(child: Text(AppLocalizations.of(context)!.noCoursesToShow));
        }
      },
    );
  }
}
