import 'package:flutter/material.dart';
import 'package:scaner_test_task/core/constants/assets.dart';

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
  OverlayEntry? _overlayEntry;

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
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      return;
    }

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: size.height * 0.15,
        left: (size.width - 100) / 2, // Center the menu
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              // mainAxisSize: MainAxisSize.min,

              children: [
                const SizedBox(height: 12.0),
                _buildMenuItem('Scan', AppImageAssets.scan.asset, () {
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                  // Handle scan
                }),
                const SizedBox(height: 12.0),
                _buildMenuItem('Gallery', AppImageAssets.gallery.asset, () {
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                  // Handle gallery
                }),
                const SizedBox(height: 12.0),
                _buildMenuItem('Files', AppImageAssets.files.asset, () {
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                  // Handle files
                }),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  Widget _buildMenuItem(String label, String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.25),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Image.asset(icon, width: 24, height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
