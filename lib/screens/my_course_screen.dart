import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/screens/create_course_screen.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:edu_nova/widgets/default_widget.dart';
import 'package:edu_nova/widgets/course_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCourseScreen extends StatefulWidget {
  const MyCourseScreen({super.key});
  static const routeName = '/my-course';

  @override
  State<MyCourseScreen> createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  @override
  void initState() {
    UserCacheData.getCacheData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(AppLocalizations.of(context)!.myCourse),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CreateCourseScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SizedBox(
          height: size(context).height - AppBar().preferredSize.height - 40,
          width: size(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder(
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

                        bool emailExists = stream.any((item) => item['email'] == UserCacheData.userEmail);

                        if (emailExists) {
                          return ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemCount: snapshot.data!.snapshot.children.length,
                            itemBuilder: (context, index) {
                              if (UserCacheData.userEmail == stream[index]['email'].toString()) {
                                return CourseCard(course: stream[index]);
                              }
                              return Container();
                            },
                          );
                        } else {
                          return DefaultWidget(title: AppLocalizations.of(context)!.youDontHaveAnyCourseYet, subtitle: AppLocalizations.of(context)!.startAddingSome, icon: Icons.add);
                        }
                      }
                      return DefaultWidget(title: AppLocalizations.of(context)!.youDontHaveAnyCourseYet, subtitle: AppLocalizations.of(context)!.startAddingSome, icon: Icons.add);
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
