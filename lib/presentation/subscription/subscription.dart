import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/subscription/success.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef _CheckoutSessionSnapshot = DocumentSnapshot<Map<String, dynamic>>;

class Subscription extends StatefulWidget {
  const Subscription({
    super.key,
    required this.checkoutSessionId,
  });

  final String checkoutSessionId;

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  late Stream<_CheckoutSessionSnapshot> _sessionStream;

  @override
  void initState() {
    super.initState();
    _sessionStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("checkout_sessions")
        .doc(widget.checkoutSessionId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_CheckoutSessionSnapshot>(
      stream: _sessionStream,
      builder: (BuildContext context,
          AsyncSnapshot<_CheckoutSessionSnapshot> snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.hasData == false) {
          return const Text('Something went wrong');
        }
        final data = snapshot.requireData.data()!;
        print(data);

        if (data.containsKey('sessionId') && data.containsKey('url')) {
         // html.window.location.href = data['url'] as String;


          return WebViewWidget(controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://success.com')) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SuccessPage()));
                } else if (request.url.startsWith('https://cancel.com')) {
                  print('https://cancel.com');
                }
                return NavigationDecision.navigate;
              },
            ),
          )..loadRequest(Uri.parse(data['url'] )));
        } else if (data.containsKey('error')) {
          return Text(
            data['error']['message'] as String? ?? 'Error processing payment.',
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
