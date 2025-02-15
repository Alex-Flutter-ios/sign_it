import 'package:flutter/material.dart';

class CustomLoaderWidget extends StatelessWidget {
  const CustomLoaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text('Processing...'),
        ],
      ),
    );
  }
}
