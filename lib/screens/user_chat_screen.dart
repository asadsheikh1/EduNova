import 'dart:io';

import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/screens/user_channel_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/widgets/message_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({super.key});
  static const routeName = '/user-chat';

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  TextEditingController messageController = TextEditingController();
  String email = '';
  String firstName = '';
  String lastName = '';
  dynamic user;
  bool isSelected = true;

  void clear() {
    messageController.clear();
    FocusScope.of(context).unfocus();
  }

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

    if (arguments != null) {
      user = arguments['user'];
      email = user?['email'];
      firstName = user?['first_name'];
      lastName = user?['last_name'];
    }

    Widget avatar;
    if (user?['imageUrl'] != null) {
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(UserChannelScreen.routeName, arguments: {'email': email});
            },
            child: ListTile(
              title: Text(
                '$firstName $lastName',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: avatar,
            ),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: const [
                    MessageCard(message: 'Hello', alignRight: true),
                    MessageCard(message: 'How are you?', alignRight: false),
                    MessageCard(message: 'Let\'s meet!', alignRight: true),
                    MessageCard(message: 'at 9:00', alignRight: true),
                    MessageCard(message: 'in North Campus 😂', alignRight: true),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterSomeText;
                    } else {
                      return null;
                    }
                  },
                  controller: messageController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.message,
                    hintStyle: TextStyle(color: kTextColor),
                    labelStyle: TextStyle(color: kTextColor),
                    suffixIcon: Tooltip(
                      message: 'Send',
                      child: IconButton(
                        onPressed: () {
                          Repository.addMessage(
                            to: email,
                            context: context,
                            date: DateTime.now().millisecondsSinceEpoch.toString(),
                            message: 'Hii, I\'m under the water, please help me!! OOOOOO',
                          );
                          clear();
                        },
                        icon: Icon(
                          Icons.send,
                          color: kMainSwatchColor,
                        ),
                      ),
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
