import 'package:flutter/material.dart';

import 'documents_tab.dart';
import 'toos_tab.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Scan'),
                onTap: () {
                  // Handle scan
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () {
                  // Handle gallery
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Files'),
                onTap: () {
                  // Handle files
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          DocumentsTab(),
          ToolsTab(),
        ],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.sizeOf(context).height * 0.05,
          ),
          child: Row(
            // alignment: Alignment.center,
            children: [
              const Spacer(),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTabItem(Icons.document_scanner, 'Documents', 0),
                      const SizedBox(width: 12),
                      _buildTabItem(Icons.build, 'Tools', 1),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showAddOptions(context),
                child: ClipRect(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRect(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xFF364EFF),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Icon(
                              Icons.add,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? const Color(0xFF364EFF)
              : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index
                  ? Colors.white
                  : Colors.black.withOpacity(0.25),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
