import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/frindship/friends_ship_view.dart';
import 'package:morgancopy/presentation/home_page/search_page.dart';
import 'package:morgancopy/presentation/post/create_post.dart';
import 'package:provider/provider.dart';
import '../../base/markets_data.dart';
import '../../data/modules/category.dart';
import '../../data/modules/post.dart';
import '../../shaerd/google-ads.dart';
import '../profile/profile_view.dart';
import 'category_page.dart';
import 'widgets/my_list_tile.dart';
import 'package:morgancopy/presentation/subscription/payment.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketsData>(builder: (context, marketsData, i) {
      List keys = marketsData.categories.keys.toList();

      return marketsData.loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
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
                                query.split(' '), marketsData.categories);
                        List<Post> posts = [];
                        for (var t in tmp) {
                          posts.add(Post().fromMap(t.data()));
                        }
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchPage(posts: posts)));
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
                Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreatePost()));
                      },
                      title: Text(
                        "puplish add",
                        style: TextStyle(fontSize: 30),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      leading: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: Image.network(
                          'https://drive.google.com/uc?export=view&id=1SVXNgYjWidATdPpPfswlWtS31DnhjB-2',
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ), // THIS
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Divider(
                  color: Colors.black,
                ),
                ...List.generate(
                  keys.length,
                  (index) => MyListTile(
                    title: marketsData.categories[keys[index]]['name'],
                    count: 1,
                    iconImage: marketsData.categories[keys[index]]['image'],
                    onTap: () {
                      // print(data[keys[index]]);
                      Category cat = Category()
                          .fromMap(marketsData.categories[keys[index]]);
                      print(cat.keys);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                    category: Category().fromMap(
                                        marketsData.categories[keys[index]]),
                                  )));
                    },
                  ),
                )
              ],
            );
    });
  }
}
