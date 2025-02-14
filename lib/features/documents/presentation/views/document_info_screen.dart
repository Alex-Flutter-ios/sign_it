import 'package:flutter/material.dart';
import 'package:scaner_test_task/core/constants/assets.dart';

import '../../data/models/document.dart';

class DocumentInfoScreen extends StatelessWidget {
  const DocumentInfoScreen({super.key, this.document});
  final Document? document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Документ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF364EFF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          InkWell(
            child: const AppImageAssets.share.assets,
            onTap: () => Share.share(),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/document_sample.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(Icons.share, 'Поделиться', () {
                  // Логика для поделиться
                }),
                const SizedBox(width: 16),
                _buildActionButton(Icons.print, 'Печать', () {
                  // Логика для печати
                }),
                const SizedBox(width: 16),
                _buildActionButton(Icons.delete, 'Удалить', () {
                  // Логика для удаления
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 28,
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
