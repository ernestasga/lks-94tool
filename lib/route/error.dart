import 'package:flutter/material.dart';

class Error404Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/2_404_Error.png",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
