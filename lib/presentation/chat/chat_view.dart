import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morgancopy/base/markets_data.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  final String? send;
  final String? receive;
  const ChatView({
    super.key,
    required this.send,
    this.receive,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<Map<String, dynamic>> chats = [];
  List<Map<String, dynamic>> mainChat = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    // print(widget.send);
    // print(widget.receive);
    return Consumer<MarketsData>(builder: (context, marketsdata, i) {
      print([widget.receive, widget.send]);
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('masseges')
              .where('sender', whereIn: [widget.receive, widget.send])
              .orderBy('date')
              //.limit(10)
              .snapshots(),
          builder: (context, data) {
            if (data.hasError) {
              return Text('Error: ${data.error}');
            }

            if (data.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (data.hasData) {
              // Process and display the data

              chats = [];
              print(data.data!.docs);
              for (var i in data.data!.docs) chats.add(i.data());
              print('receive ${widget.receive}');

              mainChat =
                  chats.where((i) => i['receive'] == widget.receive).toList();
              print(mainChat);

              return Scaffold(
                  appBar: AppBar(),
                  body: ListView(reverse: true, children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex:
                               20 ,
                            child: SizedBox(
                              height: 59,
                              width: MediaQuery.of(context).size.width * .90,
                              child: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                    hintText: "send chat"),
                              ),
                            ),
                          ),
                          Expanded(
                            flex:4,
                            child: InkWell(
                                onTap: () {
                                  if (controller.text.isNotEmpty) {
                                    marketsdata.chatSend({
                                      "receive": widget.receive,
                                      "sender": widget.send,
                                      "masseges": controller.text,
                                      "date": DateTime.now(),
                                    });
                                  }
                                  controller.clear();
                                },
                                child: Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 1.1,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.grey[400],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.purple.shade400,
                                      borderRadius: BorderRadius.circular(25)),
                                )),
                          ),
                        ],
                      ),
                    ),
                    if (mainChat.isNotEmpty)
                      ...List.generate(mainChat.length, (i) {
                        if (widget.send == mainChat[i]["sender"]) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BubbleNormal(
                              text: mainChat[i]["masseges"],
                              isSender: true,
                              color: Colors.purple.shade400,
                              tail: false,
                              textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: BubbleNormal(
                                text: mainChat[i]["masseges"],
                                isSender: false,
                                color: Colors.grey.shade400,
                                tail: false,
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ));
                        }
                      }),
                  ]));
            }
            return Text('No data available');
          });
    });
  }
}
