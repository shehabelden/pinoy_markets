import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../base/markets_data.dart';
import '../../data/modules/category.dart';
import 'widget/post_button.dart';
import 'widget/post_field.dart';

class CreatePost extends StatefulWidget {
  CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<String> path = [];
  List<Category> cats = [];

  final TextEditingController post = TextEditingController();
  Map<String, dynamic> catShow = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // final TextEditingController post = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<MarketsData>(builder: (context, marketsData, i) {
        catShow = marketsData.categories;

        List<String> keys = catShow.keys.toList();

        return Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('add pics',
                      style: TextStyle(fontSize: 18, color: Colors.green)),
                  GridView(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      childAspectRatio: 1.0, // Aspect ratio of grid items
                    ),
                    children: [
                      if (marketsData.selectedImages.isNotEmpty)
                        ...List.generate(
                            marketsData.selectedImages.length,
                            (index) => Image.file(
                                  File(marketsData.selectedImages[index]!.path),
                                  height: 100,
                                  width: 100,
                                )),
                      IconButton(
                          onPressed: () {
                            marketsData.pickMultipleImages();
                          },
                          icon: Icon(
                            Icons.photo_camera_back_rounded,
                            color: Colors.blueGrey,
                            size: 100,
                          ))
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('x',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.green)),
                    if (cats.isEmpty)
                      Column(
                        children: [
                          ListTile(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return WillPopScope(
                                      onWillPop: () async => false,
                                      child: StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                            content: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              90,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: ListView.separated(
                                              itemBuilder: (context, index) =>
                                                  ListTile(
                                                    onTap: () {
                                                      print(
                                                          catShow[keys[index]]);
                                                      if (catShow[keys[index]]
                                                              ['sub'] !=
                                                          null) {
                                                        setState(() {
                                                          path.add(keys[index]);
                                                          cats.add(Category()
                                                              .fromMap(catShow[
                                                                  keys[
                                                                      index]]));
                                                          catShow = catShow[
                                                                  keys[index]]
                                                              ['sub'];
                                                          keys = catShow.keys
                                                              .toList();
                                                        });
                                                      } else {
                                                        cats.add(Category()
                                                            .fromMap(catShow[
                                                                keys[index]]));
                                                        path.add(keys[index]);

                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    title: Text(
                                                      catShow[keys[index]]
                                                          ['name'],
                                                      style: TextStyle(
                                                          fontSize: 30),
                                                    ),
                                                    trailing: Icon(
                                                        Icons.radio_button_off),
                                                    leading: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.12,
                                                      child: Image.network(
                                                          catShow[keys[index]]
                                                              ['image']),
                                                    ),
                                                  ),
                                              separatorBuilder:
                                                  (context, index) => Divider(
                                                        color: Colors.black,
                                                      ),
                                              itemCount: keys.length),
                                        ));
                                      }),
                                    );
                                  }).then((value) {
                                setState(() {
                                  cats = cats;
                                });
                              });
                            },
                            tileColor: Colors.grey.shade200,
                            title: Text(
                              "the point of ad ",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                          Divider(
                            color: Colors.black,
                          ), // THIS
                        ],
                      ),
                    ...List.generate(
                        cats.length,
                        (index) => Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    cats = [];
                                    catShow = marketsData.categories;
                                    keys = catShow.keys.toList();
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return WillPopScope(
                                            onWillPop: () async => false,
                                            child: StatefulBuilder(
                                                builder: (context, setState) {
                                              return AlertDialog(
                                                  content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    90,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: ListView.separated(
                                                    itemBuilder: (context,
                                                            index) =>
                                                        ListTile(
                                                          onTap: () {
                                                            print(catShow[
                                                                keys[index]]);
                                                            if (catShow[keys[
                                                                        index]]
                                                                    ['sub'] !=
                                                                null) {
                                                              setState(() {
                                                                cats.add(Category()
                                                                    .fromMap(
                                                                        catShow[
                                                                            keys[index]]));
                                                                catShow =
                                                                    catShow[keys[
                                                                            index]]
                                                                        ['sub'];
                                                                keys = catShow
                                                                    .keys
                                                                    .toList();
                                                              });
                                                            } else {
                                                              cats.add(Category()
                                                                  .fromMap(catShow[
                                                                      keys[
                                                                          index]]));

                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          title: Text(
                                                            catShow[keys[index]]
                                                                ['name'],
                                                            style: TextStyle(
                                                                fontSize: 30),
                                                          ),
                                                          trailing: Icon(Icons
                                                              .radio_button_off),
                                                          leading: SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.06,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.12,
                                                            child: Image.network(
                                                                catShow[keys[
                                                                        index]]
                                                                    ['image']),
                                                          ),
                                                        ),
                                                    separatorBuilder: (context,
                                                            index) =>
                                                        Divider(
                                                          color: Colors.black,
                                                        ),
                                                    itemCount: keys.length),
                                              ));
                                            }),
                                          );
                                        }).then((value) {
                                      setState(() {
                                        cats = cats;
                                      });
                                    });
                                  },
                                  tileColor: Colors.grey.shade200,
                                  title: Text(
                                    cats[index].name!,
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  leading: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.06,
                                    width: MediaQuery.of(context).size.width *
                                        0.12,
                                    child: Image.network(cats[index].image!),
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                ), // THIS
                              ],
                            ))
                  ],
                ),
              ),
              PostField(
                post: post,
                name: "ad text",
                label: "Text Field in Dialog",
              ),
              PostButton(
                color: Colors.grey,
                func: () async {
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
                  String storagePath = path.map((e) => '/$e').join();
                  List<String> imagesFromStorage = [];
                  if (_formKey.currentState!.validate()) {
                    for (var image in marketsData.selectedImages) {
                      imagesFromStorage.add(
                          await marketsData.uploadImageToFirebaseStorage(
                              File(image!.path),
                              'products$storagePath/${DateTime.now().toString()}'));
                    }
                    marketsData.addPostToFirebaseFirestore(
                        path[path.length - 2],
                        path.last,
                        imagesFromStorage,
                        post.text
                            .replaceAll('\n', ' &^% ')
                            .split(' ')
                            .map((e) => e == "&^%" ? '\n' : e)
                            .toList());

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
