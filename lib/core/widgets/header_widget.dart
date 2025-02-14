import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    this.signFontSize,
    this.itFontSize,
    this.pageName,
  });

  final double? signFontSize;
  final double? itFontSize;
  final String? pageName;

  @override
  Widget build(BuildContext context) {
    return pageName == "tools"
        ? Text(
            'Tools ',
            style: TextStyle(
              fontSize: signFontSize ?? 24,
              fontWeight: FontWeight.bold,
            ),
          )
        : RichText(
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
