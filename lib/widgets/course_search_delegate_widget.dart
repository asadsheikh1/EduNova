import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/screens/course_detail_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseSearchDelegateWidget extends SearchDelegate {
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

            return ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: snapshot.data!.snapshot.children.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(CourseDetailScreen.routeName, arguments: stream[index]);
                  },
                  child: ListTile(
                    leading: const CircleAvatar(),
                    title: Text(stream[index]['title'].toString()),
                    subtitle: Text(stream[index]['interests'].toString()),
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

            final List<dynamic> filteredCourses = stream.where((course) {
              final String title = course['title'].toString().toLowerCase();
              final String queryText = query.toLowerCase();
              return title.contains(queryText);
            }).toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(CourseDetailScreen.routeName, arguments: filteredCourses[index]);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        filteredCourses[index]['imageUrl'].toString(),
                        scale: 5,
                      ),
                    ),
                    title: Text(filteredCourses[index]['title'].toString()),
                    subtitle: Text(filteredCourses[index]['interests'].toList().join(', '), style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
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
