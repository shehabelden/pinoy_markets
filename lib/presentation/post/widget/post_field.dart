import 'package:flutter/material.dart';

class PostField extends StatelessWidget {
  const PostField(
      {super.key, required this.post, required this.name, required this.label});
  final TextEditingController post;
  final String name;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 20),
      child: SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(fontSize: 18, color: Colors.green)),
            TextField(
              controller: post,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
