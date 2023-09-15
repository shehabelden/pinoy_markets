import 'dart:io';

import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/chat/all_chat_view.dart';
import 'package:morgancopy/presentation/frindship/friend_ship.dart';
import 'package:morgancopy/presentation/home_page/home_page.dart';
import 'package:provider/provider.dart';

import '../../base/markets_data.dart';
import '../frindship/friends_ship_view.dart';
import '../profile/profile_view.dart';

/// Flutter code sample for [BottomNavigationBar].

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    AllChatView(),
    FriendShipView(),
    ProfileView(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketsData>(builder: (context, marketData, i) {
      if (MediaQuery.of(context).size.width < 600) {
        return Scaffold(
          appBar: AppBar(title: Text('morgan'), actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () async {
                  await marketData.getProfile();
                  await marketData.paymentUserInfo();
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return WillPopScope(
                            onWillPop: () async => false,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ));
                      });

                  Navigator.pop(context);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileView()));
                },
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                ),
              ),
            ),
          ]),
          body: Center(
            child: _widgetOptions[_selectedIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'message',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_city_rounded),
                label: 'friend ship',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: (index) async {
              // check index val
              // print(index);
              if (index == 1) {
                marketData.allChatGet();
              }
              if (index == 2) {
                await marketData.gitId();
                await marketData.friendShip(7);
              }
              _onItemTapped(index);
            },
          ),
        );
      } else {
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.square(80),
              child: Container(
                height: 100,
                child: Row(
                  children: [
                    const Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text("morgan",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        )),
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Text("home"),
                          onTap: () {
                            _selectedIndex = 0;
                            _onItemTapped(_selectedIndex);
                          },
                        )),
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 20,
                          child: InkWell(
                            child: Text("mychats"),
                            onTap: () async {
                              _selectedIndex = 1;
                              _onItemTapped(_selectedIndex);

                              marketData.allChatGet();
                            },
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 20,
                          child: InkWell(
                              child: const Text("friend ship"),
                              onTap: () async {
                                _selectedIndex = 2;
                                _onItemTapped(_selectedIndex);

                                await marketData.gitId();
                                await marketData.friendShip(7);
                              }),
                        )),
                    Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 20,
                          child: InkWell(
                            child: const Text("profile"),
                            onTap: () async {
                              _selectedIndex = 3;
                              _onItemTapped(_selectedIndex);
                            },
                          ),
                        )),
                  ],
                ),
              )),
          body: Center(
            child: _widgetOptions[_selectedIndex],
          ),
        );
      }
    });
  }
}
