import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:scaner_test_task/core/constants/assets.dart';

import '../../data/models/document.dart';
import '../cubit/documents_cubit.dart';

class DocumentInfoScreen extends StatelessWidget {
  const DocumentInfoScreen({super.key});

  Widget _buildActionButton(String icon, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doc = ModalRoute.of(context)?.settings.arguments as Document?;
    if (doc == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Документ не найден')),
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
                  _buildActionButton(
                    AppImageAssets.print.asset,
                    () => cubit.printDocument(doc),
                  ),
                  const SizedBox(width: 8.0),
                  _buildActionButton(
                    AppImageAssets.delete.asset,
                    () => cubit.deleteDocument(doc.id),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: PDFView(
            filePath: doc.path,
            onError: (error) {
              debugPrint("PDFView Error: $error");
            },
          ),
        ),
      ),
    );
  }
}
