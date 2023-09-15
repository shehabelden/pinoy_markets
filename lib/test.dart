import 'package:flutter/material.dart';

class x extends StatelessWidget {
  const x({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.bottomCenter,
          radius: 1.0,
          colors: <Color>[Colors.white, Colors.white.withOpacity(.0)],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: const Text(
        'I’m burning the memories',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
