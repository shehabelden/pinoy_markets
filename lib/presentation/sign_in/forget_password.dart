import 'package:flutter/material.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(hintText: "كلمة السر"),
            ),
            const TextField(
              decoration: InputDecoration(hintText: "كلمة السر"),
            ),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.purple.shade800,
                  child: const Text("متابعه"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
