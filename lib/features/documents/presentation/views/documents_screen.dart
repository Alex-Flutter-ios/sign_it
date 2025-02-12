// documents_list/presentation/views/documents_screen.dart
import 'package:flutter/material.dart';
import 'package:scaner_test_task/features/documents/presentation/views/toos_tab.dart';

import 'documents_tab.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _tabs = [
    DocumentsTab(),
    ToolsTab(),
  ];

  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Tools',
          ),
        ],
      ),
    );
  }
}
