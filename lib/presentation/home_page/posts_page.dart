import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/home_page/post_details.dart';

import '../../data/modules/post.dart';
import '../../shaerd/google-ads.dart';

class PostsPage extends StatefulWidget {
  PostsPage({required this.catKey});
  final String catKey;

  @override
  State<PostsPage> createState() => PostsPageState();
}

class PostsPageState extends State<PostsPage> {
  // List<QueryDocumentSnapshot<Object?>> _data = [];
  List<Widget> posts = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController controller;
  DocumentSnapshot? _lastVisible;
  bool _isLoading = false;

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  Future<void> _getData() async {
    QuerySnapshot<Map<String, dynamic>> data;
    if (_lastVisible == null) {
      data = await FirebaseFirestore.instance
          .collectionGroup(widget.catKey)
          .orderBy('date', descending: true)
          // to retrieve the latest data first
          .limit(10)
          .get();
      print(data);
    } else {
      data = await FirebaseFirestore.instance
          .collectionGroup(widget.catKey)
          .orderBy('date', descending: true)
          // to retrieve the latest data first
          .startAfter([_lastVisible?['date']])
          .limit(10)
          .get();
    }

    if (data.docs.isNotEmpty) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          addWidgets(data.docs);
        });
      }
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login failed")));
    }
  }

  addWidgets(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) async {
    for (var doc in data) {
      Post post = Post().fromMap(doc.data());
      posts.add(Card(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetails(post: post)));
          },
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .35,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      post.images![index].toString(),
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: post.images!.length,
                  pagination: SwiperPagination(),
                  control: SwiperControl(),
                ),
              ),
              Text(
                post.text!,
                style: TextStyle(fontSize: 28),
              )
            ],
          ),
        ),
      ));
    }
    posts.add(const MyNativeAd());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      key: scaffoldKey,
      body: RefreshIndicator(
        child: ListView(
          controller: controller,
          children: [
            ...posts,
            Center(
              child: Visibility(
                visible: _isLoading,
                child: const SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: CircularProgressIndicator()),
              ),
            )
          ],
        ),
        onRefresh: () async {
          _lastVisible = null;
          posts.clear();
          await _getData();
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }
}
