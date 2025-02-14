import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:scaner_test_task/core/constants/assets.dart';

import '../../data/models/document.dart';
import '../cubit/documents_cubit.dart';

class DocumentInfoScreen extends StatefulWidget {
  const DocumentInfoScreen({super.key});

  @override
  State<DocumentInfoScreen> createState() => _DocumentInfoScreenState();
}

class _DocumentInfoScreenState extends State<DocumentInfoScreen> {
  int _currentPage = 0;
  int _totalPages = 0;

  late PDFViewController _pdfViewController;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildActionButton(String icon, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(icon),
    );
  }

  List<Widget> _buildPageIndicators(int currentPage, int totalPages) {
    final List<Widget> indicators = [];
    for (int i = 0; i < totalPages; i++) {
      indicators.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: i == currentPage ? const Color(0xFF364EFF) : Color(0xFFF2F4FF),
        ),
      ));
    }

    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    final doc = ModalRoute.of(context)?.settings.arguments as Document?;
    if (doc == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Document not found')),
      );
    }
    final DocumentsCubit cubit = BlocProvider.of<DocumentsCubit>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF2F4FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFF2F4FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF364EFF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    AppImageAssets.share.asset,
                    () => cubit.shareDocument(doc),
                  ),
                  const SizedBox(width: 8.0),
                  _buildActionButton(
                    AppImageAssets.print.asset,
                    () => cubit.printDocument(doc),
                  ),
                  const SizedBox(width: 8.0),
                  _buildActionButton(AppImageAssets.delete.asset, () {
                    cubit.deleteDocument(doc.id);
                    Navigator.of(context).pop();
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24.0),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          children: [
            Expanded(
              child: PDFView(
                filePath: doc.path,
                swipeHorizontal: true,
                // pageFling: true,
                onViewCreated: (PDFViewController vc) {
                  _pdfViewController = vc;
                },
                onRender: (pages) {
                  setState(() {
                    _totalPages = pages ?? 0;
                  });
                },
                onPageChanged: (page, total) {
                  setState(() {
                    _currentPage = page ?? 0;
                    _totalPages = total ?? 0;
                  });
                },
                onError: (error) {
                  debugPrint('PDFView Error: $error');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicators(_currentPage, _totalPages),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
