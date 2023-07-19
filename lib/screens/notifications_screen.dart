import 'dart:convert';

import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/screens/user_channel_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);
  static const routeName = '/notifications';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController bodyController = TextEditingController();
  Map<dynamic, dynamic>? devices;
  String? token;
  String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(AppLocalizations.of(context)!.sendNotifications),
        elevation: 0,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: Repository.databaseDevice.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text(AppLocalizations.of(context)!.noDataAvailable);
          }

          return Form(
            key: formKey,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.pleaseEnterSomeText;
                        } else {
                          return null;
                        }
                      },
                      controller: bodyController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        hintText: 'Please subscribe to Python from Scratch for Beginners 2023',
                        floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                        hintStyle: TextStyle(color: kTextColor),
                        labelStyle: TextStyle(color: kTextColor),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                      ),
                      maxLines: 5,
                    ),
                  ),
                  StreamBuilder(
                    stream: Repository.databaseUser.onValue,
                    builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: data.values.map((user) {
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
                                  Navigator.of(context).pushNamed(UserChannelScreen.routeName, arguments: {'email': user['email']});
                                },
                                child: StreamBuilder(
                                  stream: Repository.databaseDevice.onValue,
                                  builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> dSnapshot) {
                                    if (dSnapshot.hasData) {
                                      return ListTile(
                                        leading: avatar,
                                        title: Text(user['email']),
                                        trailing: FilledButton(
                                          onPressed: () async {
                                            if (formKey.currentState!.validate()) {
                                              var dataSnapshot = dSnapshot.data!.snapshot.value;
                                              devices = dataSnapshot as Map<dynamic, dynamic>?;

                                              if (devices != null) {
                                                devices!.forEach((key, value) {
                                                  if (value['email'].toString() == user['email']) {
                                                    token = value['token'];
                                                  }
                                                });
                                              }
                                              var data = {
                                                'to': token,
                                                'priority': 'high',
                                                'notification': {'title': '${UserCacheData.userEmail}: EduNova', 'body': bodyController.text, "sound": "jetsons_doorbell"},
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

                                              bodyController.clear();
                                              token = '';
                                              flutterToast('Notification sent successfully');
                                            }
                                          },
                                          child: Text(AppLocalizations.of(context)!.send),
                                        ),
                                      );
                                    } else {
                                      return const CircularProgressIndicator.adaptive();
                                    }
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return const CircularProgressIndicator.adaptive();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
