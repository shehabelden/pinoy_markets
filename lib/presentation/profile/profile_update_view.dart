import 'package:flutter/material.dart';

class ProfileUpdateView extends StatelessWidget {
  const ProfileUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
          ),
          Text("تعديل"),
          TextField(
            decoration: InputDecoration(hintText: "name"),
          ),
        ],
      ),
    );
  }
}
