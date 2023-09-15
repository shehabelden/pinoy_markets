import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morgancopy/presentation/subscription/subscription.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _DashboardPage();
}

class _DashboardPage extends State<Payment> {
  var _productId = '';


  void _onSelectProduct(String? id) {
    setState(() => _productId = id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'You can buy any of our memberships as a gift for you or someone else',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              const SizedBox(height: 32),
              // displaying products which is active
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('subscription')
                    .where('active', isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('$snapshot.error'));
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  var docs = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doc = docs[index];
                      return RadioListTile(
                        secondary: Image.network('${doc['images'][0]}'),
                        groupValue: _productId,
                        value: doc.id,
                        onChanged: _onSelectProduct,
                        subtitle:doc['description']==null?null: Text('${doc['description']}'),
                        title: Text('${doc['name']}'),
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                // mainAxisSize: MainAxisSize.c,
                children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () async {

                          final price = await FirebaseFirestore.instance
                              .collection('subscription')
                              .doc(_productId)
                              .collection('prices')
                              .where('active', isEqualTo: true)
                              .limit(1)
                              .get();
                            FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection("checkout_sessions")
                              .add({
                            "client": "web",
                            "mode": "subscription",
                            "price": price.docs[0].id,
                            'success_url': 'https://success.com/{CHECKOUT_SESSION_ID}',
                            'cancel_url': 'https://cancel.com/',
                          }).then((value){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Subscription(
                                      checkoutSessionId: value.id,
                                    ),
                                  ));
                            });


                        },
                        child: const Text('Subscribe'),
                      ),
                    )


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}