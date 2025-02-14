import 'package:flutter/material.dart';
import 'package:scaner_test_task/core/constants/assets.dart';
import 'package:scaner_test_task/core/widgets/header_widget.dart';

class ToolsTab extends StatelessWidget {
  const ToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              signFontSize: 30.0,
              itFontSize: 30.0,
              pageName: "tools",
            ),
            Image.asset(AppImageAssets.gear.asset),
          ],
        ),
      ),
    );
  }
}
