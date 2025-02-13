import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
    this.signFontSize,
    this.itFontSize,
  });

  final double? signFontSize;
  final double? itFontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        children: [
          TextSpan(
            text: 'Sign ',
            style: TextStyle(
              fontSize: signFontSize ?? 24,
            ),
          ),
          TextSpan(
            text: 'it',
            style: TextStyle(
              fontFamily: 'DancingScrip',
              fontSize: itFontSize ?? 24,
              color: Color(0xFF364EFF),
            ),
          ),
        ],
      ),
    );
  }
}
