import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/screens/likes_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:edu_nova/widgets/video_player_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});
  static const routeName = '/video-player';

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  TextEditingController callIdController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  List<String> commentList = [];
  String? likeId;
  bool isLike = false;
  String? subscribeId;
  bool isSubscribed = false;
  Map<dynamic, dynamic>? likes;
  Map<dynamic, dynamic>? subscribers;

  @override
  Widget build(BuildContext context) {
    final playlist = ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(playlist['title'].toString()),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              VideoPlayerWidget(playlist: playlist),
              StreamBuilder<DatabaseEvent>(
                stream: Repository.databaseLike.onValue,
                builder: (context, snapshot) {
                  Map<dynamic, dynamic>? map = snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

                  List<dynamic> lStream = [];
                  lStream.clear();
                  if (map != null) {
                    lStream = map.values.where((item) => item['courseId'] == playlist['time']).toList();
                    likes = map;

                    likes!.forEach((key, value) {
                      if (value['email'] == UserCacheData.userEmail && value['courseId'] == playlist['time']) {
                        likeId = value['likeId'];
                        isLike = true;
                      }
                    });
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (isLike == true && likeId != null) {
                            Repository.deleteLikeVideo(
                              date: likeId!,
                              context: context,
                            );
                            likeId = null;
                            isLike = false;
                          } else {
                            Repository.addLikeVideo(
                              date: DateTime.now().millisecondsSinceEpoch.toString(),
                              courseId: playlist['time'],
                              context: context,
                            );
                          }
                        },
                        color: kMainSwatchColor,
                        icon: Icon(isLike ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(LikesScreen.routeName, arguments: lStream);
                        },
                        child: Text(
                          '${lStream.length} ${AppLocalizations.of(context)!.likes}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Column(
                children: [
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.comment, style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text(AppLocalizations.of(context)!.addYourCommentHere, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor)),
                    trailing: IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) => Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              left: 16.0,
                              right: 16.0,
                              top: 16.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)!.pleaseEnterCourseTitle;
                                      }
                                      return null;
                                    },
                                    controller: commentController,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!.comment,
                                      floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                                      hintStyle: TextStyle(color: kTextColor),
                                      labelStyle: TextStyle(color: kTextColor),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      filled: true,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: size(context).width,
                                    child: FilledButton(
                                      child: Text(AppLocalizations.of(context)!.add),
                                      onPressed: () {
                                        Repository.addComment(
                                          context: context,
                                          date: DateTime.now().millisecondsSinceEpoch.toString(),
                                          to: playlist['time'],
                                          description: commentController.text,
                                        );
                                        commentController.clear();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        color: kMainSwatchColor,
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: Repository.databaseComment.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      } else {
                        if (snapshot.hasData) {
                          Map<dynamic, dynamic>? map = snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
                          List<dynamic> cStream = [];
                          cStream.clear();
                          if (map != null) {
                            cStream = map.values.where((comment) => comment['to'] == playlist['time']).toList();
                          }

                          return Column(
                            children: [
                              ...cStream.map((comment) {
                                return StreamBuilder(
                                  stream: Repository.databaseUser.onValue,
                                  builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                                    if (snapshot.hasData) {
                                      Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                                      List<dynamic> uStream = [];
                                      uStream.clear();
                                      final filteredUsers = map.values.where((user) {
                                        final email = user['email'].toString();
                                        return email == comment['from'];
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
                                            onLongPress: () {
                                              if (comment['from'].toString() == UserCacheData.userEmail) {
                                                AlertDialog alert = AlertDialog(
                                                  title: Text(AppLocalizations.of(context)!.delete),
                                                  content: Text(AppLocalizations.of(context)!.areYouSureYouWantToDeleteYourComment),
                                                  actions: [
                                                    SizedBox(
                                                      child: FilledButton(
                                                        child: Text(AppLocalizations.of(context)!.cancel),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: FilledButton(
                                                        child: Text(AppLocalizations.of(context)!.remove),
                                                        onPressed: () {
                                                          Repository.deleteComment(context: context, date: comment['commentId']);

                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              }
                                            },
                                            child: StreamBuilder(
                                              stream: Repository.databaseUser.onValue,
                                              builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                                                if (snapshot.hasData) {
                                                  final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;

                                                  String firstName = '';
                                                  String lastName = '';

                                                  data.forEach((key, value) {
                                                    if (value['email'].toString() == comment['from']) {
                                                      firstName = value['first_name'];
                                                      lastName = value['last_name'];
                                                    }
                                                  });

                                                  return ListTile(
                                                    leading: avatar,
                                                    title: Text('$firstName $lastName'),
                                                    subtitle: Text(comment['description']),
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
                              }),
                            ],
                          );
                        }
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
