import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/subscription/payment.dart';
import 'package:provider/provider.dart';
import '../../base/markets_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'show_location.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController controller = TextEditingController();
  List<String> languge = ["en", "ph"];
  String? selct;
  List<String> color = ["dark", "light"];
  String? selctColor;

  langugeOption(val) {
    print(val);
    setState(() {
      selct = val ?? '';
    });
  }

  selctColorOptions(val) {
    print(val);
    setState(() {
      selctColor = val ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketsData>(builder: (context, marketsData, index) {
      return marketsData.profile.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    marketsData.profile["profileImage"] != null
                        ? GestureDetector(
                            onTap: () {
                              marketsData.pickProfileImages();
                            },
                            child: Container(
                              height: 120,
                              width: 120,
                              child: Image.network(
                                  marketsData.profile["profileImage"]),
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4B179E),
                                      Color(0xFF3350B3),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(120)),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              marketsData.pickProfileImages();
                            },
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4B179E),
                                      Color(0xFF3350B3),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(120)),
                            ),
                          ),
                    Text(
                      marketsData.profile!["email"] != null
                          ? marketsData.profile!["email"]
                          : "",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GestureDetector(
                            onTap: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('AlertDialog Title'),
                                  content:
                                      const Text('AlertDialog description'),
                                  actions: <Widget>[
                                    AlertDialog(
                                      title: Text("name"),
                                      content: TextField(
                                        controller: controller,
                                        decoration:
                                            InputDecoration(hintText: "name"),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          if (controller.text != null) {
                                            marketsData.userUpdate({
                                              "name": controller.text,
                                            });
                                          }
                                        },
                                        child: Text("ok"))
                                  ],
                                ),
                              );
                            },
                            child: const Text("name"),
                          ),
                        ),
                        marketsData.subscription == null
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('subscripe'),
                                        content: const Text('subscripe'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Payment()));
                                              },
                                              child: Text("subscripe now"))
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text('No Subscription'),
                                ))
                            : Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                    onTap: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('subscripe'),
                                          content: Column(
                                            children: [
                                              Text(marketsData
                                                  .subscription!.status),
                                              Text(
                                                  'subscription ends: ${marketsData.subscription!.currentPeriodEnd}'),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child:
                                        Text(marketsData.subscription!.status)),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GestureDetector(
                            onTap: () {
                              if (Platform.isAndroid || Platform.isIOS) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowLocation(
                                            url:
                                                'https://www.google.com/maps/search/?api=1&query= ${marketsData.profile!["latitude"]}, ${marketsData.profile!["longitude"]}')));
                              } else {
                                launch(
                                    'https://www.google.com/maps/search/?api=1&query= ${marketsData.profile!["latitude"]}, ${marketsData.profile!["longitude"]}');
                              }
                            },
                            child: Text("get my location"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GestureDetector(
                            onTap: () {
                              final snackBar = SnackBar(
                                content: Text('your location updated'),
                              );
                              marketsData.getLocation().then((value) {
                                marketsData.addUserLocation(
                                    value!.latitude, value!.longitude);
                              }).then((value) => ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar));
                            },
                            child: Text("update my location"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: GestureDetector(
                            onTap: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('AlertDialog Title'),
                                  content:
                                      const Text('AlertDialog description'),
                                  actions: <Widget>[
                                    StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, selct);
                                                },
                                                child: Text('okay'))
                                          ],
                                          title: Text("languge"),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RadioListTile(
                                                groupValue: selct,
                                                value: languge[0],
                                                onChanged: (val) {
                                                  print(val);
                                                  setState(() {
                                                    selct = val ?? '';
                                                  });
                                                },
                                                title: Text(languge[0]),
                                              ),
                                              RadioListTile(
                                                groupValue: selct,
                                                value: languge[1],
                                                onChanged: (val) {
                                                  print(val);
                                                  setState(() {
                                                    selct = val ?? '';
                                                  });
                                                },
                                                title: Text(languge[1]),
                                              ),
                                            ],
                                          ));
                                    }),
                                  ],
                                ),
                              );
                            },
                            child: const Text("languge"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Divider(
                            height: 10,
                            thickness: 1,
                            indent: 10,
                            endIndent: 0,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: const Text("speed-jet"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InkWell(
                              onTap: () {},
                              child: const Text("Connect with us")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InkWell(
                              onTap: () => marketsData.auth.signOut(),
                              child: const Text("log out")),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
