import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  const PostButton({
    super.key,
    required this.color,
    required this.func,
  });
  final Color color;
  final Function func;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        func();
      },
      child: Container(
        color: color,
        alignment: Alignment.center,
        child: const Text(
          "add",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
