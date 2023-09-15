import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:morgancopy/data/modules/UserData.dart';
import 'package:morgancopy/shaerd/google-ads.dart';
import 'package:provider/provider.dart';
import '../../base/markets_data.dart';
import '../../data/modules/post.dart';
import '../chat/chat_view.dart';
import '../home_page/post_details.dart';

class SellerView extends StatelessWidget {
  const SellerView({super.key, required this.posts, required this.userData});
  final List<Post> posts;
  final UserData userData;
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketsData>(builder: (context, marketsData, index) {
      marketsData.paymentUserInfo();
      return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 125.0, left: 125),
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
                Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Text(
                    userData.email != null ? userData.email : "",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                InkWell(
                  onTap: () {
                    marketsData.chatAddme({
                      "send": userData.id,
                      "receive": userData.id,
                      "name": userData.name
                    });
                    marketsData.chatAddhim({
                      "receive": userData.id,
                      "send": marketsData.auth.currentUser!.uid,
                      "name": marketsData.auth.currentUser!.displayName
                    });

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatView(
                                  send: marketsData.auth.currentUser!.uid,
                                  receive: userData.id,
                                )));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("conect with me"),
                  ),
                ),
              ],
            ),
            MyNativeAd(),
            if (posts.isNotEmpty)
              ...List.generate(
                  posts.length,
                  (i) => Card(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PostDetails(post: posts[i])));
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .35,
                                child: Swiper(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Image.network(
                                      posts[i].images![index].toString(),
                                      fit: BoxFit.fill,
                                    );
                                  },
                                  itemCount: posts[i].images!.length,
                                  pagination: SwiperPagination(),
                                  control: SwiperControl(),
                                ),
                              ),
                              Text(
                                posts[i].text!,
                                style: TextStyle(fontSize: 28),
                              )
                            ],
                          ),
                        ),
                      )),
            posts.isNotEmpty ? MyNativeAd() : Text('no posts yet'),
          ],
        ),
      );
    });
  }
}
