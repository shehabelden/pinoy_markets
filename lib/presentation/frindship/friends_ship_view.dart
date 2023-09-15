import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/frindship/seler_view.dart';
import 'package:provider/provider.dart';

import '../../base/markets_data.dart';
import '../../data/modules/post.dart';
import '../profile/widget/user_container.dart';

class FriendShipView extends StatelessWidget {
  const FriendShipView({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketsData>(builder: (context, marketData, i) {
      return marketData.usersNearMe.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: marketData.usersNearMe.length,
              itemBuilder: (c, i) {
                return InkWell(
                    onTap: () async {
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
                      List<Post> posts = [];
                      var tmp = await marketData
                          .getUser(marketData.usersNearMe[i].id);
                      for (var tm in tmp) {
                        posts.add(Post().fromMap(tm.data()));
                      }
                      Navigator.pop(context);
                      // marketData.getSeller(marketData.usersNearMe[i].id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerView(
                                  posts: posts,
                                  userData: marketData.usersNearMe[i])));
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Display the post image
                          Image.network(
                            marketData.usersNearMe[i].image ??
                                'https://drive.google.com/uc?export=view&id=1-MvSxL4d6iHqedG4Gx36gLcezbBml-Y_',
                            fit: BoxFit.cover,
                          ),

                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              marketData.usersNearMe[i].name!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
              });
    });
  }
}
