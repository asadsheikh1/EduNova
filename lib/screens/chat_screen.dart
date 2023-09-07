import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:edu_nova/widgets/user_search_delegate_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  static const routeName = '/chat';

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
                                  return Text('Connect Instantly 💬', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold));
                                }
                              }
                            }
                            return const Center(child: CircularProgressIndicator.adaptive());
                          },
                        ),
                        subtitle: Text('Chat, Connect, Share', style: Theme.of(context).textTheme.labelLarge),
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
                                          delegate: UserSearchDelegateWidget(),
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
                      title: Text('Chats', style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Text('Your conversations here', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor)),
                    ),
                    StreamBuilder(
                      stream: Repository.databaseChat.onValue,
                      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        } else {
                          if (snapshot.hasData) {
                            Map<dynamic, dynamic>? map = snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
                            List<String> cEmails;

                            if (map != null) {
                              Set<String> uniqueEmails = {};

                              map.forEach((key, value) {
                                if (value['from'] == UserCacheData.userEmail || value['to'] == UserCacheData.userEmail) {
                                  uniqueEmails.add(value['from']);
                                  uniqueEmails.add(value['to']);
                                }
                              });

                              cEmails = uniqueEmails.toList();
                              print(cEmails);
                            }

                            return const Text('Nothing');
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
