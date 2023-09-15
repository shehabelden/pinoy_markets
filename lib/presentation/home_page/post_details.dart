import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/profile/widget/user_container.dart';
import 'package:provider/provider.dart';

import '../../base/markets_data.dart';
import '../../data/modules/UserData.dart';
import '../../data/modules/post.dart';
import '../../shaerd/google-ads.dart';
import '../frindship/seler_view.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  UserData? data;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.post.userId)
        .get()
        .then((value) {
      setState(() {
        value.data();
        data = UserData.fromJson(value.data()!);
      });

// print(profile),
    });
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  widget.post.images![index],
                  fit: BoxFit.fill,
                );
              },
              itemCount: widget.post.images!.length,
              pagination: SwiperPagination(),
              control: SwiperControl(),
            ),
          ),
          Text(widget.post.text!, style: TextStyle(fontSize: 28)),
          Consumer<MarketsData>(builder: (context, marketData, i) {
            return data == null
                ? CircularProgressIndicator()
                : GestureDetector(
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
                      var tmp = await marketData.getUser(widget.post.userId!);
                      for (var tm in tmp) {
                        posts.add(Post().fromMap(tm.data()));
                      }
                      Navigator.pop(context);
                      // marketData.getSeller(marketData.usersNearMe[i].id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SellerView(posts: posts, userData: data!)));
                    },
                    child: UserContainer(
                      name: data!.name,
                      image: data!.image,
                    ),
                  );
          }),
          MyNativeAd()
        ],
      ),
    );
  }
}
