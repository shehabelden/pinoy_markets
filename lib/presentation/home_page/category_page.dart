import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/home_page/posts_page.dart';
import 'package:morgancopy/presentation/home_page/search_page.dart';
import 'package:provider/provider.dart';
import '../../base/markets_data.dart';
import '../../data/modules/category.dart';
import '../../data/modules/post.dart';
import 'widgets/my_list_tile.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({
    Key? key,
    required this.category,
  }) : super(key: key);
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketsData>(builder: (context, marketsData, i) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            //await getData();
          },
        ),
        appBar: AppBar(
          title: Text(category.name!),
        ),
        body: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  onSubmitted: (query) async {
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
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> tmp =
                        await marketsData.searchAllCats(
                            query.split(' '), category.sub!);
                    List<Post> posts = [];
                    for (var t in tmp) {
                      posts.add(Post().fromMap(t.data()));
                    }
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchPage(posts: posts)));
                  },
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'what are you looking for?',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                )),
            ...List.generate(
              category.keys!.length,
              (index) => MyListTile(
                title: category.sub![category.keys![index]]['name'],
                count: 1,
                iconImage: category.sub![category.keys![index]]['image'],
                onTap: () async {
                  print(category.sub![category.keys![index]]['sub']);
                  if (category.sub![category.keys![index]]['sub'] != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryPage(
                                category: Category().fromMap(
                                    category.sub![category.keys![index]]))));
                  } else {
                    QuerySnapshot<Map<String, dynamic>> querySnapshot =
                        await FirebaseFirestore.instance
                            .collectionGroup(category.keys![index])
                            .get();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostsPage(
                                  catKey: category.keys![index],
                                )));
                  }
                },
              ),
            )
          ],
        ),
      );
    });
  }
}

List<String> getPathToKey(Map<dynamic, dynamic> map, dynamic targetKey) {
  List<String> path = [];

  bool search(Map<dynamic, dynamic> currentMap) {
    for (var key in currentMap.keys) {
      path.add(key.toString());
      if (key == targetKey) {
        return true;
      } else if (currentMap[key] is Map) {
        if (search(currentMap[key])) {
          return true;
        }
      }
      path.removeLast();
    }
    return false;
  }

  if (search(map)) {
    return path;
  } else {
    return [];
  }
}
