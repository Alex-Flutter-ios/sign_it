import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34.0),
        gradient: LinearGradient(
          colors: [
            Color(0xFF364EFF),
            Color(0xFF5436FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // color: buttonColor,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            // fontFamily: "Urbanist",
          ),
        ),
      ),
    );
  }
}
