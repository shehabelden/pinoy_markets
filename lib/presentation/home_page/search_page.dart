import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/home_page/post_details.dart';

import '../../data/modules/post.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key, required this.posts}) : super(key: key);

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: posts.isNotEmpty
          ? ListView.builder(
              itemCount: posts.length,
              shrinkWrap: true,
              itemBuilder: (c, i) {
                return Card(
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
                          height: MediaQuery.of(context).size.height * .35,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
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
                );
              },
            )
          : Text('no posts'),
    );
  }
}
