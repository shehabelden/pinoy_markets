import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/chat/chat_view.dart';
import 'package:provider/provider.dart';

import '../../base/markets_data.dart';
import '../profile/widget/user_container.dart';

class AllChatView extends StatelessWidget {
  const AllChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketsData>(builder: (context, marketsdata, i) {
      return marketsdata.allChat.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: ListView.builder(
                  itemCount: marketsdata.allChat.length,
                  itemBuilder: (c, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatView(
                                      send: marketsdata.auth.currentUser!.uid,
                                      receive: marketsdata.allChat[i]
                                          ["receive"],
                                    )));
                      },
                      child: UserContainer(
                        name: marketsdata.allChat[i]["name"],
                        image: marketsdata.allChat[i]["profileImage"],
                      ),
                    );
                  },
                ),
              ),
            );
    });
  }
}
