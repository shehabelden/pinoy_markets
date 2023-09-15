import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  final String? name;
  final String? image;

  const UserContainer({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    print(name!);
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, left: 30, right: 30),
      child: Container(
        color: Colors.grey.shade200,
        height: 80,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: image == null
                  ? Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(45)),
                    )
                  : Container(
                      height: 45,
                      width: 45,
                      child: Image.network(image!),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(45)),
                    ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$name"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
